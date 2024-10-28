//{"colid":1,"data":2,"midrow":10,"prnew":9,"prold":8,"result":4,"rowall":6,"rowallsize":7,"rowinfo":11,"rowptr":0,"rowtotal":5,"start":12,"vec":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cpu_csr(global int* rowptr, global int* colid, global float* data, global float* vec, global float* result, int rowtotal, global int* rowall, int rowallsize, global float* prold, global float* prnew, int midrow, global int* rowinfo, int start) {
  int r = get_global_id(0);
  int getnumsum = get_global_size(0);

  int startRow = rowinfo[hook(11, start)];
  int endRow = rowinfo[hook(11, start + 1)];
  r += startRow;

  for (; r < endRow; r += getnumsum) {
    int row = r;

    float sum = 0;

    int start = rowptr[hook(0, row)];
    int end = rowptr[hook(0, row + 1)];
    for (int i = start; i < end; i++) {
      int col = colid[hook(1, i)];
      sum = mad(data[hook(2, i)], prold[hook(8, col)], sum);
    }
    sum = sum * 0.85 + (1.0 - 0.85) * vec[hook(3, row)];
    prnew[hook(9, row)] = sum;
  }
}