//{"Width":3,"indexes":2,"poolMap":1,"pooldim":4,"prevfeatMap":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pooling(global float* prevfeatMap, global float* poolMap, global int* indexes, int Width, int pooldim) {
  const int xIn = get_global_id(0);
  const int yIn = get_global_id(1);

  const int z = get_global_id(2);

  float max = 0;
  int index = 0;
  for (int r = 0; r < 2; r++) {
    for (int c = 0; c < 2; c++) {
      if (prevfeatMap[hook(0, (yIn + c) * Width * z + (xIn + r))] > max) {
        max = prevfeatMap[hook(0, (yIn + c) * Width * z + (xIn + r))];
        index = c * 2 + r;
      }
    }
  }

  poolMap[hook(1, (xIn + yIn * pooldim + z * pooldim * pooldim))] = max;
  indexes[hook(2, (xIn + yIn * pooldim + z * pooldim * pooldim))] = index;
}