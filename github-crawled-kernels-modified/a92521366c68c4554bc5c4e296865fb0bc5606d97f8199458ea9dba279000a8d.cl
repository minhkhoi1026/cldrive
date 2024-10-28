//{"Core_N":10,"Delta":5,"FactorM":4,"core_index":2,"core_val":3,"current":9,"index":0,"mult":11,"nnz":7,"order":6,"rank":8,"tmp":12,"tmp2":13,"val":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_delta(global int* index, global float* val, global int* core_index, global float* core_val, global float* FactorM, global float* Delta, int order, int nnz, int rank, int current, int Core_N, int mult) {
  int pos = get_global_id(0);
  if (pos < nnz) {
    int i, j, k, l, pre_val = pos * rank, pre2 = pos * order, pre3, pre4;
    float tmp[105];
    int tmp2[25];
    for (i = 0; i < rank; i++)
      tmp[hook(12, i)] = 0;
    for (i = 0; i < order; i++)
      tmp2[hook(13, i)] = index[hook(0, pre2 + i)];
    for (i = 0; i < Core_N; i++) {
      pre3 = 0;
      pre4 = i * order;
      j = core_index[hook(2, pre4 + current)];
      float temp = core_val[hook(3, i)];
      for (k = 0; k < order; k++) {
        if (k != current) {
          int row = tmp2[hook(13, k)], col = core_index[hook(2, pre4 + k)];
          temp *= FactorM[hook(4, pre3 + row * rank + col)];
        }
        pre3 += mult;
      }
      tmp[hook(12, j)] += temp;
    }
    for (i = 0; i < rank; i++)
      Delta[hook(5, pre_val + i)] = tmp[hook(12, i)];
  }
}