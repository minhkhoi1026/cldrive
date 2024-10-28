//{"cached_source":6,"gauss_kernel":0,"height":5,"input":2,"kernel_radius":1,"output":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussy(global float* gauss_kernel, int kernel_radius, global float* input, global float* output, int width, int height, local float* cached_source) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int2 local_size = (int2)(get_local_size(0), get_local_size(1));
  int2 local_id = (int2)(get_local_id(0), get_local_id(1));
  int2 group_id = (int2)(get_group_id(0), get_group_id(1));

  int top_index = group_id.y * local_size.y - kernel_radius;
  int cache_height_len = kernel_radius + local_size.y + kernel_radius;

  for (int i = local_id.y; i < cache_height_len; i += local_size.y) {
    cached_source[hook(6, i + local_id.x * cache_height_len)] = input[hook(2, min(height - 1, max(top_index + i, 0)) * width + coord.x)];
  }

  float sum = 0;

  write_mem_fence(0x01);

  for (int i = -kernel_radius; i <= kernel_radius; i++) {
    sum += gauss_kernel[hook(0, i + kernel_radius)] * cached_source[hook(6, local_id.y + kernel_radius + i + local_id.x * cache_height_len)];
  }

  output[hook(3, coord.x + coord.y * width)] = sum;
}