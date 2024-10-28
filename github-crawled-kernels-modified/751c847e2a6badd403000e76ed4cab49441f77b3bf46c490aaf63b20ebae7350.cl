//{"a":0,"answer":2,"b":1,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Mat_Mult(global const double* a, global const double* b, global double* answer, int n) {
  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  double value = n;
  for (int k = 0; k < n; k++) {
    double elementA = a[hook(0, (i * n) + k)];
    double elementB = b[hook(1, (k * n) + j)];
    value += elementA * elementB;
  }

  answer[hook(2, (i * n) + j)] = value;
}