//{"bitsums":0,"dst":2,"n":3,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void partition(global int* bitsums, global float* src, global float* dst, int n) {
  int i = get_global_id(0);

  if (i == 0) {
    if (bitsums[hook(0, 0)] == 1)
      dst[hook(2, 0)] = src[hook(1, 0)];
    else
      dst[hook(2, n - 1)] = src[hook(1, 0)];
  } else if (i > 0) {
    if (bitsums[hook(0, i)] > bitsums[hook(0, i - 1)])
      dst[hook(2, bitsums[ihook(0, i) - 1)] = src[hook(1, i)];
    else
      dst[hook(2, n - 1 - (i - bitsums[ihook(0, i)))] = src[hook(1, i)];
  }
}