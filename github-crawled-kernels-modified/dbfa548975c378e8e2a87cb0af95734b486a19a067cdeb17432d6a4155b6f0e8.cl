//{"incx":2,"n":0,"res":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Isamin_naive(int n, global float* x, int incx, global int* res) {
  int lowest_index = 0;
  float lowest_value = fabs(x[hook(1, 0)]);

  for (unsigned int i = 1; i < n; ++i) {
    float current_value = fabs(x[hook(1, i * incx)]);

    if (current_value < lowest_value) {
      lowest_value = current_value;
      lowest_index = i;
    }
  }

  res[hook(3, 0)] = lowest_index;
}