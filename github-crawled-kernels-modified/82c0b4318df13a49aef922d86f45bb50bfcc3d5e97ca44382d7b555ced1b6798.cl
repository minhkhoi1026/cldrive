//{"binary":3,"n":1,"size":2,"weights":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binarize_weights_kernel(global float* weights, int n, int size, global float* binary) {
  int f = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (f >= n)
    return;
  int i = 0;
  float mean = 0;
  for (i = 0; i < size; ++i) {
    mean += fabs(weights[hook(0, f * size + i)]);
  }
  mean = mean / size;
  for (i = 0; i < size; ++i) {
    binary[hook(3, f * size + i)] = (weights[hook(0, f * size + i)] > 0) ? mean : -mean;
  }
}