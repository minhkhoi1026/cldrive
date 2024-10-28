//{"cached_source":5,"gauss_kernel":0,"input":2,"kernel_radius":1,"output":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gaussx(global float* gauss_kernel, int kernel_radius, global float* input, global float* output, int width, local float* cached_source) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  float sum = 0;

  for (int i = -kernel_radius; i <= kernel_radius; i++) {
    sum += gauss_kernel[hook(0, i + kernel_radius)] * input[hook(2, min(width - 1, max(coord.x + i, 0)) + coord.y * width)];
  }

  output[hook(3, coord.x + coord.y * width)] = sum;
}