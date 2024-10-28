//{"cols":2,"dim":4,"maxrl":8,"out":5,"rowLengths":3,"rowall":6,"rowallsize":7,"rowinfo":10,"rowsetzf":9,"start":11,"val":0,"vec":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cpu_csr(global const float* restrict val, global const float* restrict vec, global const int* restrict cols, global const int* restrict rowLengths, const int dim, global float* restrict out, global int* rowall, const int rowallsize, const int maxrl, const int rowsetzf, global int* rowinfo, int start) {
  int r = get_global_id(0);

  int getnumsum = get_global_size(0);

  int startRow = rowinfo[hook(10, start)];
  int endRow = rowinfo[hook(10, start + 1)];
  r += startRow;

  for (; r < endRow; r += getnumsum) {
    int row = r;

    float result = 0.0;
    int max = rowLengths[hook(3, row)];
    for (int i = 0; i < max; i++) {
      int ind = i + row * maxrl;

      result += val[hook(0, ind)] * vec[hook(1, cols[ihook(2, ind))];
    }
    out[hook(5, row)] = result;
  }
}