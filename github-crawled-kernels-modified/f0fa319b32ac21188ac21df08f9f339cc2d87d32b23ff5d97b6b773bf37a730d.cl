//{"cols":2,"dim":4,"maxrl":8,"out":5,"rowLengths":3,"rowall":6,"rowallsize":7,"val":0,"vec":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cpu_csr(global const float* restrict val, global const float* restrict vec, global const int* restrict cols, global const int* restrict rowLengths, const int dim, global float* restrict out, global int* rowall, const int rowallsize, const int maxrl) {
  int r = get_global_id(0);
  int getnumsum = get_global_size(0);

  for (; r < rowallsize; r += getnumsum) {
    int row = rowall[hook(6, r)];
    float result = 0.0;
    int max = rowLengths[hook(3, row)];
    for (int i = 0; i < max; i++) {
      int ind = i + row * maxrl;

      result += val[hook(0, ind)] * vec[hook(1, cols[ihook(2, ind))];
    }
    out[hook(5, row)] = result;
  }
}