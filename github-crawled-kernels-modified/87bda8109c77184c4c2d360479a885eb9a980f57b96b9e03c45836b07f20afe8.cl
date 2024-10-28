//{"n":1,"partial":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum_partial(global float* partial, int n) {
  float sum = 0.f;
  for (int i = 0; i < n; ++i) {
    sum += partial[hook(0, i)];
  }
  partial[hook(0, 0)] = sum;
}