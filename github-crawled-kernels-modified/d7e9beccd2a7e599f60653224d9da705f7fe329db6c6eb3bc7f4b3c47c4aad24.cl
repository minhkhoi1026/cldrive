//{"batch":2,"biases":1,"n":3,"output":0,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_bias_kernel(global float* output, global float* biases, int batch, int n, int size) {
  int index = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (index >= n * size * batch)
    return;
  int i = index % size;
  index /= size;
  int j = index % n;
  index /= n;
  int k = index;
  output[hook(0, (k * n + j) * size + i)] += biases[hook(1, j)];
}