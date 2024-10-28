//{"g_idata":0,"g_odata":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void d_vector_sum_scalar(global double* g_idata, global double* g_odata, unsigned int n) {
  int i = get_local_id(0);
  if (i == 0) {
    for (int j = 0; j < n; j++)
      g_odata[hook(1, 0)] += g_idata[hook(0, j)];
  }
}