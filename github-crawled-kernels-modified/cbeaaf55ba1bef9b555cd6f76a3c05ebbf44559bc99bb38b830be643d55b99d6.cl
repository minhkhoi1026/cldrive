//{"grid1":1,"grid2":2,"gridSizeX":3,"gridSizeY":4,"resultGrid":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t linearSampler = 0 | 2 | 0x20;
kernel void AddOpenCLGrid2D(global float* resultGrid, global float* grid1, global float* grid2, int gridSizeX, int gridSizeY) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);
  const unsigned int idx = y * gridSizeX + x;

  if (x > gridSizeX * gridSizeY)
    return;

  float grid1val = grid1[hook(1, idx)];
  float grid2val = grid2[hook(2, idx)];
  resultGrid[hook(0, idx)] = grid1val + grid2val;

  return;
}