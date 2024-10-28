//{"data":0,"dir":4,"size":2,"stage":3,"twiddle":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DIT4C2C(global double* data, global double2* twiddle, const int size, unsigned int stage, unsigned int dir) {
  int idX = get_global_id(0);

  int powMaxLvl = 7;
  int powLevels = stage / powMaxLvl;
  int powRemain = stage % powMaxLvl;
  int powX = 1;
  int powXm1 = 1;
  int x;
  for (x = 0; x < powLevels; x++) {
    powX *= pow(4.0f, powMaxLvl);
  }
  powX *= pow(4.0f, powRemain);
  powXm1 = powX / 4;

  int clipOne, clipTwo, clipThr, clipFou;
  int yIndex, kIndex;
  yIndex = idX / powXm1;
  kIndex = idX % powXm1;

  clipOne = 2 * (kIndex + yIndex * powX + 0 * powXm1);
  clipTwo = 2 * (kIndex + yIndex * powX + 1 * powXm1);
  clipThr = 2 * (kIndex + yIndex * powX + 2 * powXm1);
  clipFou = 2 * (kIndex + yIndex * powX + 3 * powXm1);

  double2 TEMPC;
  double8 SIGA = (double8)(data[hook(0, clipOne + 0)], data[hook(0, clipOne + 1)], data[hook(0, clipTwo + 0)], data[hook(0, clipTwo + 1)], data[hook(0, clipThr + 0)], data[hook(0, clipThr + 1)], data[hook(0, clipFou + 0)], data[hook(0, clipFou + 1)]);

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