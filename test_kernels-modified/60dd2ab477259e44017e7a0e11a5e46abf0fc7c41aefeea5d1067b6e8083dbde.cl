//{"g_idata":0,"g_odata":1,"n":2,"sdata":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce3(global float* g_idata, global float* g_odata, unsigned int n, local float* sdata) {
  unsigned int tid = get_local_id(0);
  unsigned int i = get_group_id(0) * (get_local_size(0) * 2) + get_local_id(0);

  sdata[hook(3, tid)] = (i < n) ? g_idata[hook(0, i)] : 0;
  if (i + get_local_size(0) < n)
    sdata[hook(3, tid)] += g_idata[hook(0, i + get_local_size(0))];

  barrier(0x01);

  for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (tid < s) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + s)];
    }
    barrier(0x01);
  }

  if (tid == 0)
    g_odata[hook(1, get_group_id(0))] = sdata[hook(3, 0)];
}