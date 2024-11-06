
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void recon(global int* index, global float* val, global int* core_index, global float* core_val, global float* FactorM, global float* Error_T, int order, int nnz, int rank, int Core_N, int mult) {
  int pos = get_global_id(0);
  if (pos < nnz) {
    int i, j, k, l, pre2 = pos * order, pre3, pre4;
    float res = 0;
    int tmp2[25];
    for (i = 0; i < order; i++)
      tmp2[hook(11, i)] = index[hook(0, pre2 + i)];
    for (i = 0; i < Core_N; i++) {
      pre3 = 0;
      pre4 = i * order;
      float temp = core_val[hook(3, i)];
      for (k = 0; k < order; k++) {
        temp *= FactorM[hook(4, pre3 + tmp2[khook(11, k) * rank + core_index[phook(2, pre4 + k))];
        pre3 += mult;
      }
      res += temp;
    }
    Error_T[hook(5, pos)] = res;
  }
}