//{"data":0,"dir":5,"stage":4,"twiddle":1,"type":6,"x":2,"y":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DIT4C2C(global double* data, global double2* twiddle, const int x, const int y, const int stage, const int dir, const int type) {
  int idX = get_global_id(0);
  int idY = get_global_id(1);

  int powMaxLvl = 7;
  int powLevels = stage / powMaxLvl;
  int powRemain = stage % powMaxLvl;
  int powX = 1;
  int powXm1 = 1;
  int xx;
  for (xx = 0; xx < powLevels; xx++) {
    powX *= pow(4.0f, powMaxLvl);
  }
  powX *= pow(4.0f, powRemain);
  powXm1 = powX / 4;

  int clipOne, clipTwo, clipThr, clipFou, yIndex, kIndex, red, coeffUse;

  int BASE = 0;
  int STRIDE = 1;

  switch (type) {
    case 1:
      BASE = idY * x;
      yIndex = idX / powXm1;
      kIndex = idX % powXm1;
      red = x / 4;
      coeffUse = kIndex * (x / powX);
      break;
    case 2:
      BASE = idX;
      STRIDE = x;
      yIndex = idY / powXm1;
      kIndex = idY % powXm1;
      red = y / 4;
      coeffUse = kIndex * (y / powX);
      break;
  }

  clipOne = 2 * (BASE + STRIDE * (kIndex + yIndex * powX + 0 * powXm1));
  clipTwo = 2 * (BASE + STRIDE * (kIndex + yIndex * powX + 1 * powXm1));
  clipThr = 2 * (BASE + STRIDE * (kIndex + yIndex * powX + 2 * powXm1));
  clipFou = 2 * (BASE + STRIDE * (kIndex + yIndex * powX + 3 * powXm1));

  double8 SIGA = (double8)(data[hook(0, clipOne + 0)], data[hook(0, clipOne + 1)], data[hook(0, clipTwo + 0)], data[hook(0, clipTwo + 1)], data[hook(0, clipThr + 0)], data[hook(0, clipThr + 1)], data[hook(0, clipFou + 0)], data[hook(0, clipFou + 1)]);

  int quad, buad;
  double2 TEMPC, clSet1;

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
  if (kIndex != 0) {
    TEMPC.x = SIGA.s4 * clSet1.x - SIGA.s5 * clSet1.y;
    TEMPC.y = SIGA.s5 * clSet1.x + SIGA.s4 * clSet1.y;
    SIGA.s4 = TEMPC.x;
    SIGA.s5 = TEMPC.y;
  }

  quad = (2 * coeffUse) / red;
  buad = (2 * coeffUse) % red;
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
  if (kIndex != 0) {
    TEMPC.x = SIGA.s2 * clSet1.x - SIGA.s3 * clSet1.y;
    TEMPC.y = SIGA.s3 * clSet1.x + SIGA.s2 * clSet1.y;
    SIGA.s2 = TEMPC.x;
    SIGA.s3 = TEMPC.y;
  }

  quad = (3 * coeffUse) / red;
  buad = (3 * coeffUse) % red;
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
  if (kIndex != 0) {
    TEMPC.x = SIGA.s6 * clSet1.x - SIGA.s7 * clSet1.y;
    TEMPC.y = SIGA.s7 * clSet1.x + SIGA.s6 * clSet1.y;
    SIGA.s6 = TEMPC.x;
    SIGA.s7 = TEMPC.y;
  }
  if (dir == 1) {
    data[hook(0, clipOne + 0)] = SIGA.s0 + SIGA.s2 + SIGA.s4 + SIGA.s6;
    data[hook(0, clipOne + 1)] = SIGA.s1 + SIGA.s3 + SIGA.s5 + SIGA.s7;
    data[hook(0, clipTwo + 0)] = SIGA.s0 - SIGA.s2 + SIGA.s5 - SIGA.s7;
    data[hook(0, clipTwo + 1)] = SIGA.s1 - SIGA.s3 - SIGA.s4 + SIGA.s6;
    data[hook(0, clipThr + 0)] = SIGA.s0 + SIGA.s2 - SIGA.s4 - SIGA.s6;
    data[hook(0, clipThr + 1)] = SIGA.s1 + SIGA.s3 - SIGA.s5 - SIGA.s7;
    data[hook(0, clipFou + 0)] = SIGA.s0 - SIGA.s2 - SIGA.s5 + SIGA.s7;
    data[hook(0, clipFou + 1)] = SIGA.s1 - SIGA.s3 + SIGA.s4 - SIGA.s6;
  } else if (dir == 0) {
    data[hook(0, clipOne + 0)] = SIGA.s0 + SIGA.s2 + SIGA.s4 + SIGA.s6;
    data[hook(0, clipOne + 1)] = SIGA.s1 + SIGA.s3 + SIGA.s5 + SIGA.s7;
    data[hook(0, clipTwo + 0)] = SIGA.s0 - SIGA.s2 - SIGA.s5 + SIGA.s7;
    data[hook(0, clipTwo + 1)] = SIGA.s1 - SIGA.s3 + SIGA.s4 - SIGA.s6;
    data[hook(0, clipThr + 0)] = SIGA.s0 + SIGA.s2 - SIGA.s4 - SIGA.s6;
    data[hook(0, clipThr + 1)] = SIGA.s1 + SIGA.s3 - SIGA.s5 - SIGA.s7;
    data[hook(0, clipFou + 0)] = SIGA.s0 - SIGA.s2 + SIGA.s5 - SIGA.s7;
    data[hook(0, clipFou + 1)] = SIGA.s1 - SIGA.s3 - SIGA.s4 + SIGA.s6;
  }
}