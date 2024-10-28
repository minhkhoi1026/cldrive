//{"g_idata":0,"g_odata":1,"n":2,"sdata":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce1(global float* g_idata, global float* g_odata, unsigned int n, local float* sdata) {
  unsigned int tid = get_local_id(0);
  unsigned int i = get_global_id(0);

  sdata[hook(3, tid)] = (i < n) ? g_idata[hook(0, i)] : 0;

  barrier(0x01);

  for (unsigned int s = 1; s < get_local_size(0); s *= 2) {
    int index = 2 * s * tid;

    if (index < get_local_size(0)) {
      sdata[hook(3, index)] += sdata[hook(3, index + s)];
    }

    barrier(0x01);
  }

  if (tid == 0)
    g_odata[hook(1, get_group_id(0))] = sdata[hook(3, 0)];
}