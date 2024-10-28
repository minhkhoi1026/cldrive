//{"iDx":2,"iDy":3,"max_dist":4,"vIn":0,"vOut":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SignedDistanceTransformUnsignedByte(global const unsigned char* vIn, global unsigned char* vOut, int iDx, int iDy, int max_dist) {
  int iGID = get_global_id(0);

  if (iGID >= (iDx * iDy)) {
    return;
  }
  int idX = iGID % iDy;
  int idY = iGID / iDy;
  float2 pos = (float2)(idX, idY);

  int minX = clamp(idX - max_dist, 0, iDx);
  int maxX = clamp(idX + max_dist, 0, iDx);
  int minY = clamp(idY - max_dist, 0, iDy);
  int maxY = clamp(idY + max_dist, 0, iDy);

  float minVal = 0.0f;
  const float max_distf = convert_float(max_dist);

  if (vIn[hook(0, iGID)] > 128) {
    float shortest_distance = max_distf;
    for (int y = minY; y < maxY; y++) {
      for (int x = minX; x < maxX; x++) {
        float dist = length(pos - (float2)(x, y));

        if (dist < shortest_distance && vIn[hook(0, y * iDy + x)] <= 128) {
          shortest_distance = dist;
        }
      }
    }

    minVal = shortest_distance / max_distf;
  } else {
    float shortest_distance = max_distf;
    for (int y = minY; y < maxY; y++) {
      for (int x = minX; x < maxX; x++) {
        float dist = length(pos - (float2)(x, y));

        if (dist < shortest_distance && vIn[hook(0, y * iDy + x)] > 128) {
          shortest_distance = dist;
        }
      }
    }

    minVal = -shortest_distance / max_distf;
  }

  float mapped = clamp(minVal * 0.5f + 0.5f, 0.0f, 1.0f);
  unsigned char val = convert_uchar(mapped * 255.0f);

  vOut[hook(1, iGID)] = val;
}