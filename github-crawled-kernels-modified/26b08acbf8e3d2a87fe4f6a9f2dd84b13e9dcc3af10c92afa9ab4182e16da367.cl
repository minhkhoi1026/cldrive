//{"g_idata":0,"g_odata":1,"n":3,"sdata":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global const float* g_idata, global float* g_odata, local float* sdata, const unsigned int n) {
  const unsigned int tid = get_local_id(0);
  unsigned int i = (get_group_id(0) * (get_local_size(0) * 2)) + tid;
  const unsigned int gridSize = get_local_size(0) * 2 * get_num_groups(0);
  const unsigned int blockSize = get_local_size(0);

  sdata[hook(2, tid)] = 0;

  while (i < n) {
    sdata[hook(2, tid)] += g_idata[hook(0, i)] + g_idata[hook(0, i + blockSize)];
    i += gridSize;
  }
  barrier(0x01);

  for (unsigned int s = blockSize / 2; s > 0; s >>= 1) {
    if (tid < s) {
      sdata[hook(2, tid)] += sdata[hook(2, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0) {
    g_odata[hook(1, get_group_id(0))] = sdata[hook(2, 0)];
  }
}