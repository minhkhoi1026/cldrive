//{"bitmap":6,"colid":1,"data":2,"midrow":9,"prnew":8,"prold":7,"result":4,"row_num":5,"rowptr":0,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gpu_csr_ve_slm_pm_fs(global int* rowptr, global int* colid, global float* data, global float* vec, global float* result, int row_num, global unsigned long* bitmap, global float* prold, global float* prnew, int midrow) {
  int r = get_global_id(0);
  int getnumsum = get_global_size(0);

  for (; r < midrow; r += getnumsum) {
    int row = r;

    float sum = 0;

    int start = rowptr[hook(0, row)];
    int end = rowptr[hook(0, row + 1)];
    for (int i = start; i < end; i++) {
      int col = colid[hook(1, i)];
      sum = mad(data[hook(2, i)], prold[hook(7, col)], sum);
    }
    sum = sum * 0.85 + (1.0 - 0.85) * vec[hook(3, row)];
    prnew[hook(8, row)] = sum;
  }
}