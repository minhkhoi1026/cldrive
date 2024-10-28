//{"g_idata":0,"g_odata":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void s_vector_sum_sqrt(global float* g_idata, global float* g_odata, unsigned int n) {
  int i = get_local_id(0);
  if (i == 0) {
    for (int j = 0; j < n; j++)
      g_odata[hook(1, 0)] += g_idata[hook(0, j)];
  }
  if (i == 0)
    g_odata[hook(1, 0)] = sqrt(g_odata[hook(1, 0)]);
}