//{"colid":1,"data":2,"midrow":6,"result":4,"row_num":5,"rowptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_ve_slm_pm_fs(global int* rowptr, global int* colid, global float* data, global float* vec, global float* result, int row_num, int midrow) {
  int row = get_global_id(0);
  int getnumsum = get_global_size(0);

  for (; row < midrow; row += getnumsum) {
    float sum = result[hook(4, row)];
    int start = rowptr[hook(0, row)];
    int end = rowptr[hook(0, row + 1)];
    for (int i = start; i < end; i++) {
      int col = colid[hook(1, i)];
      sum = mad(data[hook(2, i)], vec[hook(3, col)], sum);
    }
    result[hook(4, row)] = sum;
  }
}