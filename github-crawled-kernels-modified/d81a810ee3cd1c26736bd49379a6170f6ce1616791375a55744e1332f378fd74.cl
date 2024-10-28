//{"data":0,"dir":6,"stage":5,"twiddle":1,"type":7,"x":2,"y":3,"z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DIT2C2C(global double* data, global double2* twiddle, const int x, const int y, const int z, const int stage, const int dir, const int type) {
  int idX = get_global_id(0);
  int idY = get_global_id(1);
  int idZ = get_global_id(2);

  int BASE = 0;
  int STRIDE = 1;

  int powMaxLvl = 11;
  int powLevels = stage / powMaxLvl;
  int powRemain = stage % powMaxLvl;
  int powX = 1;
  int powXm1 = 1;
  int xx;
  for (xx = 0; xx < powLevels; xx++) {
    powX *= pow(2.0f, powMaxLvl);
  }
  powX *= pow(2.0f, powRemain);
  powXm1 = powX / 2;

  int yIndex, kIndex, clipOne, clipTwo, coeffUse, red, quad, buad;
  double2 clSet1;

  switch (type) {
    case 1:
      BASE = idZ * x * y + idY * x;
      yIndex = idX / powXm1;
      kIndex = idX % powXm1;
      coeffUse = kIndex * (x / powX);
      red = x / 4;
      break;
    case 2:
      BASE = idZ * x * y + idX;
      STRIDE = x;
      yIndex = idY / powXm1;
      kIndex = idY % powXm1;
      coeffUse = kIndex * (y / powX);
      red = y / 4;
      break;
    case 3:
      BASE = idY * x + idX;
      STRIDE = x * y;
      yIndex = idZ / powXm1;
      kIndex = idZ % powXm1;
      coeffUse = kIndex * (z / powX);
      red = z / 4;
      break;
  }

  clipOne = 2 * (BASE + STRIDE * (kIndex + yIndex * powX));
  clipTwo = 2 * (BASE + STRIDE * (kIndex + yIndex * powX + powXm1));

  quad = coeffUse / red;
  buad = coeffUse % red;

  switch (quad) {
    case 0:
      clSet1 = (double2)(twiddle[hook(1, buad)].x, twiddle[hook(1, buad)].y);
      break;
    case 1:
      clSet1 = (double2)(twiddle[hook(1, buad)].y, -twiddle[hook(1, buad)].x);
      break;
    case 2:
      clSet1 = (double2)(-twiddle[hook(1, buad)].x, -twiddle[hook(1, buad)].y);
      break;
    case 3:
      clSet1 = (double2)(-twiddle[hook(1, buad)].y, twiddle[hook(1, buad)].x);
      break;
  }
  if (dir == 0)
    clSet1.y *= -1;

  double4 LOC = (double4)(data[hook(0, clipOne + 0)], data[hook(0, clipOne + 1)], data[hook(0, clipTwo + 0)], data[hook(0, clipTwo + 1)]);
  double4 FIN = (double4)(LOC.x + LOC.z * clSet1.x - LOC.w * clSet1.y, LOC.y + LOC.w * clSet1.x + LOC.z * clSet1.y, LOC.x - LOC.z * clSet1.x + LOC.w * clSet1.y, LOC.y - LOC.w * clSet1.x - LOC.z * clSet1.y);

  data[hook(0, clipOne + 0)] = FIN.x;
  data[hook(0, clipOne + 1)] = FIN.y;
  data[hook(0, clipTwo + 0)] = FIN.z;
  data[hook(0, clipTwo + 1)] = FIN.w;
}