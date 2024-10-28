//{"MaxX":16,"MaxY":18,"MinX":17,"MinY":19,"Potential":0,"atZ":30,"atx":27,"aty":28,"atz":29,"clAtomXPos":1,"clAtomYPos":2,"clAtomZNum":4,"clAtomZPos":3,"clBlockStartPositions":6,"clfParams":5,"dz":12,"full3dints":26,"height":8,"loadBlocksX":20,"loadBlocksY":21,"loadSlicesZ":22,"pixelscale":13,"sigma":23,"slice":9,"slices":10,"startx":24,"starty":25,"width":7,"xBlocks":14,"yBlocks":15,"z":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clBinnedAtomicPotentialOpt(global float2* Potential, global const float* restrict clAtomXPos, global const float* restrict clAtomYPos, global const float* restrict clAtomZPos, global const int* restrict clAtomZNum, constant float* clfParams, global const int* restrict clBlockStartPositions, int width, int height, int slice, int slices, float z, float dz, float pixelscale, int xBlocks, int yBlocks, float MaxX, float MinX, float MaxY, float MinY, int loadBlocksX, int loadBlocksY, int loadSlicesZ, float sigma, float startx, float starty, int full3dints) {
  int xid = get_global_id(0);
  int yid = get_global_id(1);
  int lid = get_local_id(0) + get_local_size(0) * get_local_id(1);
  int Index = xid + width * yid;
  int topz = slice - loadSlicesZ;
  int bottomz = slice + loadSlicesZ;
  float sumz = 0.0f;
  int gx = get_group_id(0);
  int gy = get_group_id(1);
  if (topz < 0)
    topz = 0;
  if (bottomz >= slices)
    bottomz = slices - 1;

  local float atx[256];
  local float aty[256];
  local float atz[256];
  local int atZ[256];

  float integrals = full3dints;

  int startj = fmax(floor(((starty + gy * get_local_size(1) * pixelscale) * yBlocks) / (MaxY - MinY)) - loadBlocksY, 0);
  int endj = fmin(ceil(((starty + (gy + 1) * get_local_size(1) * pixelscale) * yBlocks) / (MaxY - MinY)) + loadBlocksY, yBlocks - 1);
  int starti = fmax(floor(((startx + gx * get_local_size(0) * pixelscale) * xBlocks) / (MaxX - MinX)) - loadBlocksX, 0);
  int endi = fmin(ceil(((startx + (gx + 1) * get_local_size(0) * pixelscale) * xBlocks) / (MaxX - MinX)) + loadBlocksX, xBlocks - 1);

  for (int k = topz; k <= bottomz; k++) {
    for (int j = startj; j <= endj; j++) {
      int start = clBlockStartPositions[hook(6, k * xBlocks * yBlocks + xBlocks * j + starti)];
      int end = clBlockStartPositions[hook(6, k * xBlocks * yBlocks + xBlocks * j + endi + 1)];

      int gid = start + lid;

      if (lid < end - start) {
        atx[hook(27, lid)] = clAtomXPos[hook(1, gid)];
        aty[hook(28, lid)] = clAtomYPos[hook(2, gid)];
        atz[hook(29, lid)] = clAtomZPos[hook(3, gid)];
        atZ[hook(30, lid)] = clAtomZNum[hook(4, gid)];
      }

      barrier(0x01);

      float p2 = 0;
      for (int l = 0; l < end - start; l++) {
        float xyrad2 = (startx + xid * pixelscale - atx[hook(27, l)]) * (startx + xid * pixelscale - atx[hook(27, l)]) + (starty + yid * pixelscale - aty[hook(28, l)]) * (starty + yid * pixelscale - aty[hook(28, l)]);

        int ZNum = atZ[hook(30, l)];
        for (int h = 0; h <= full3dints; h++) {
          float rad = native_sqrt(xyrad2 + (z - h * dz / integrals - atz[hook(29, l)]) * (z - h * dz / integrals - atz[hook(29, l)]));

          if (rad < 0.25f * pixelscale)
            rad = 0.25f * pixelscale;

          float p1 = 0;

          if (rad < 3.0f) {
            p1 += (150.4121417f * native_recip(rad) * clfParams[hook(5, (ZNum - 1) * 12)] * native_exp(-2.0f * 3.141592f * rad * native_sqrt(clfParams[hook(5, (ZNum - 1) * 12 + 1)])));
            p1 += (150.4121417f * native_recip(rad) * clfParams[hook(5, (ZNum - 1) * 12 + 2)] * native_exp(-2.0f * 3.141592f * rad * native_sqrt(clfParams[hook(5, (ZNum - 1) * 12 + 2 + 1)])));
            p1 += (150.4121417f * native_recip(rad) * clfParams[hook(5, (ZNum - 1) * 12 + 4)] * native_exp(-2.0f * 3.141592f * rad * native_sqrt(clfParams[hook(5, (ZNum - 1) * 12 + 4 + 1)])));
            p1 += (266.5157269f * clfParams[hook(5, (ZNum - 1) * 12 + 6)] * native_exp(-3.141592f * rad * 3.141592f * rad / clfParams[hook(5, (ZNum - 1) * 12 + 6 + 1)]) * native_powr(clfParams[hook(5, (ZNum - 1) * 12 + 6 + 1)], -1.5f));
            p1 += (266.5157269f * clfParams[hook(5, (ZNum - 1) * 12 + 8)] * native_exp(-3.141592f * rad * 3.141592f * rad / clfParams[hook(5, (ZNum - 1) * 12 + 8 + 1)]) * native_powr(clfParams[hook(5, (ZNum - 1) * 12 + 8 + 1)], -1.5f));
            p1 += (266.5157269f * clfParams[hook(5, (ZNum - 1) * 12 + 10)] * native_exp(-3.141592f * rad * 3.141592f * rad / clfParams[hook(5, (ZNum - 1) * 12 + 10 + 1)]) * native_powr(clfParams[hook(5, (ZNum - 1) * 12 + 10 + 1)], -1.5f));

            sumz += (h != 0) * (p1 + p2) * 0.5f;
            p2 = p1;
          }
        }
      }

      barrier(0x01);
    }
  }
  if (xid < width && yid < height) {
    Potential[hook(0, Index)].x = native_cos((dz / integrals) * sigma * sumz);
    Potential[hook(0, Index)].y = native_sin((dz / integrals) * sigma * sumz);
  }
}