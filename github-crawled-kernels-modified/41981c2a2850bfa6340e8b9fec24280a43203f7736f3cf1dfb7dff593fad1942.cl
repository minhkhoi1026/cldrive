//{"iDx":2,"iDy":3,"vIn":0,"vOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DistanceTransform(global const float* vIn, global float* vOut, int iDx, int iDy) {
  int iGID = get_global_id(0);

  if (iGID >= (iDx * iDy)) {
    return;
  }

  float minVal = 0x1.fffffep127f;

  for (int y = 0; y < iDy; y++) {
    for (int x = 0; x < iDx; x++) {
      if (vIn[hook(0, y * iDy + x)] >= 1.0f) {
        int idX = iGID % iDy;
        int idY = iGID / iDy;
        float dist = sqrt((float)((idX - x) * (idX - x) + (idY - y) * (idY - y)));

        if (dist < minVal) {
          minVal = dist;
        }
      }
    }
  }

  vOut[hook(1, iGID)] = minVal;
}