//{"coeff":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fir12(global float* input, global float* output) {
  int i = get_global_id(0);
  int j = 0;
  int coeff[12] = {5, 7, 5, 7, 5, 7, 5, 7, 5, 7, 5, 7};
  for (j = 0; j < 12; j++) {
    output[hook(1, i)] += coeff[hook(2, j)] * (input[hook(0, i + 12 - j - 1)]);
  }
}