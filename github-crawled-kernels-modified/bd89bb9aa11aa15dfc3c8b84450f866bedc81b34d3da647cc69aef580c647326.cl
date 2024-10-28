//{"g_idata1":0,"g_idata2":1,"g_odata":2,"n":3,"sdata":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void d_vector_dot(global double* g_idata1, global double* g_idata2, global double* g_odata, unsigned int n, local volatile double* sdata) {
  unsigned int tid = get_local_id(0);
  unsigned int i = get_group_id(0) * (get_local_size(0) * 2) + get_local_id(0);
  unsigned int gridSize = 256 * 2 * get_num_groups(0);
  sdata[hook(4, tid)] = 0;

  while (i < n) {
    sdata[hook(4, tid)] += (g_idata1[hook(0, i)] * g_idata2[hook(1, i)]);

    if (0 || i + 256 < n)
      sdata[hook(4, tid)] += (g_idata1[hook(0, i + 256)] * g_idata2[hook(1, i + 256)]);
    i += gridSize;
  }

  barrier(0x01);

  if (256 >= 512) {
    if (tid < 256) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 256)];
    }
    barrier(0x01);
  }
  if (256 >= 256) {
    if (tid < 128) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 128)];
    }
    barrier(0x01);
  }
  if (256 >= 128) {
    if (tid < 64) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 64)];
    }
    barrier(0x01);
  }

  if (tid < 32) {
    if (256 >= 64) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 32)];
    }
    if (256 >= 32) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 16)];
    }
    if (256 >= 16) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 8)];
    }
    if (256 >= 8) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 4)];
    }
    if (256 >= 4) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 2)];
    }
    if (256 >= 2) {
      sdata[hook(4, tid)] += sdata[hook(4, tid + 1)];
    }
  }

  if (tid == 0)
    g_odata[hook(2, get_group_id(0))] = sdata[hook(4, 0)];
}