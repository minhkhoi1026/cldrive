//{"biases":1,"n":2,"output":0,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scale_bias_kernel(global float* output, global float* biases, int n, int size) {
  size_t global_x = get_global_id(0);
  size_t global_y = get_global_id(1);
  size_t global_z = get_global_id(2);
  size_t filter = global_z - get_global_offset(2);
  size_t x_dim_size = get_global_size(0);
  size_t offset = x_dim_size * global_y + global_x;
  if (offset < size)
    output[hook(0, global_z * size + offset)] *= biases[hook(1, filter)];
}