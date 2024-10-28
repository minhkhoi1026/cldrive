//{"colid":1,"data":2,"midrow":6,"result":4,"rowallsize":5,"rowptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cpu_csr_ve_slm_pm_fs(global int* rowptr, global int* colid, global float* data, global float* vec, global float* result, int rowallsize, int midrow) {
  int row = get_global_id(0) + midrow;
  int getnumsum = get_global_size(0);

  for (; row < rowallsize; row += getnumsum) {
    float sum = 0;

    int start = rowptr[hook(0, row)];
    int end = rowptr[hook(0, row + 1)];
    for (int i = start; i < end; i++) {
      int col = colid[hook(1, i)];
      sum = mad(data[hook(2, i)], vec[hook(3, col)], sum);
    }

    result[hook(4, row)] = sum;
  }
}