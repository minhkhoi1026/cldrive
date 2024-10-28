//{"incx":2,"n":0,"res":3,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Isamax_naive(int n, global float* x, int incx, global int* res) {
  int maxIndex = 0;
  float currentMax = fabs(x[hook(1, maxIndex)]);

  for (int i = 1; i < n; i++) {
    float current = fabs(x[hook(1, i * incx)]);

    if (current > currentMax) {
      currentMax = current;
      maxIndex = i;
    }
  }

  res[hook(3, 0)] = maxIndex;
}