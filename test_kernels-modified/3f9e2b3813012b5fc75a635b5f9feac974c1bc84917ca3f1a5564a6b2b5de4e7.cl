//{"data":0,"dir":4,"size":2,"stage":3,"twiddle":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DIT2C2C(global double* data, global double2* twiddle, const int size, unsigned int stage, unsigned int dir) {
  int idX = get_global_id(0);

  int powMaxLvl = 11;
  int powLevels = stage / powMaxLvl;
  int powRemain = stage % powMaxLvl;
  int powX = 1;
  int powXm1 = 1;
  int x;
  for (x = 0; x < powLevels; x++)
    powX *= pow(2.0f, powMaxLvl);
  powX *= pow(2.0f, powRemain);
  powXm1 = powX / 2;

  int yIndex = idX / powXm1;
  int kIndex = idX % powXm1;

  int clipStart = 2 * (kIndex + yIndex * powX);
  int clipEnd = 2 * (kIndex + yIndex * powX + powXm1);
  int coeffUse = kIndex * (size / powX);

  int red = size / 4;
  double2 clSet1;

  int quad = coeffUse / red;
  int buad = coeffUse % red;

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

  double4 LOC = (double4)(data[hook(0, clipStart + 0)], data[hook(0, clipStart + 1)], data[hook(0, clipEnd + 0)], data[hook(0, clipEnd + 1)]);
  double4 FIN = (double4)(LOC.x + LOC.z * clSet1.x - LOC.w * clSet1.y, LOC.y + LOC.w * clSet1.x + LOC.z * clSet1.y, LOC.x - LOC.z * clSet1.x + LOC.w * clSet1.y, LOC.y - LOC.w * clSet1.x - LOC.z * clSet1.y);

  data[hook(0, clipStart + 0)] = FIN.x;
  data[hook(0, clipStart + 1)] = FIN.y;
  data[hook(0, clipEnd + 0)] = FIN.z;
  data[hook(0, clipEnd + 1)] = FIN.w;
}