//{"binary":3,"input":0,"n":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void binarize_input_kernel(global float* input, int n, int size, global float* binary) {
  int s = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (s >= size)
    return;
  int i = 0;
  float mean = 0;
  for (i = 0; i < n; ++i) {
    mean += fabs(input[hook(0, i * size + s)]);
  }
  mean = mean / n;
  for (i = 0; i < n; ++i) {
    binary[hook(3, i * size + s)] = (input[hook(0, i * size + s)] > 0) ? mean : -mean;
  }
}