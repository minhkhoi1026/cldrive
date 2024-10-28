//{"g_idata":0,"g_odata":1,"n":2,"sdata":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce6(global float* g_idata, global float* g_odata, unsigned int n, local volatile float* sdata) {
  unsigned int tid = get_local_id(0);
  unsigned int i = get_group_id(0) * (get_local_size(0) * 2) + get_local_id(0);
  unsigned int gridSize = 128 * 2 * get_num_groups(0);
  sdata[hook(3, tid)] = 0;

  while (i < n) {
    sdata[hook(3, tid)] += g_idata[hook(0, i)];

    if (1 || i + 128 < n)
      sdata[hook(3, tid)] += g_idata[hook(0, i + 128)];
    i += gridSize;
  }

  barrier(0x01);

  if (128 >= 512) {
    if (tid < 256) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 256)];
    }
    barrier(0x01);
  }
  if (128 >= 256) {
    if (tid < 128) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 128)];
    }
    barrier(0x01);
  }
  if (128 >= 128) {
    if (tid < 64) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 64)];
    }
    barrier(0x01);
  }

  if (tid < 32) {
    if (128 >= 64) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 32)];
    }
    if (128 >= 32) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 16)];
    }
    if (128 >= 16) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 8)];
    }
    if (128 >= 8) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 4)];
    }
    if (128 >= 4) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 2)];
    }
    if (128 >= 2) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + 1)];
    }
  }

  if (tid == 0)
    g_odata[hook(1, get_group_id(0))] = sdata[hook(3, 0)];
}