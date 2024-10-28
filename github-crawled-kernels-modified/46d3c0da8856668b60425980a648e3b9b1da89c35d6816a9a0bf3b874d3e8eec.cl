//{"g_debug":6,"gauss_kernel":0,"height":5,"input":2,"kernel_radius":1,"output":3,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gauss2d(constant float* gauss_kernel, int kernel_radius, global float* input, global float* output, int width, int height, global float* g_debug) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));

  int kernel_diameter = kernel_radius * 2 + 1;
  float sum = 0;
  if (coord.x == 0 && coord.y == 0) {
    for (int y = -kernel_radius; y <= kernel_radius; y++) {
      for (int x = -kernel_radius; x <= kernel_radius; x++) {
        g_debug[hook(6, (x + kernel_radius) + (y + kernel_radius) * kernel_diameter)] = gauss_kernel[hook(0, (x + kernel_radius) + (y + kernel_radius) * kernel_diameter)];
      }
    }
  }

  for (int y = -kernel_radius; y <= kernel_radius; y++) {
    for (int x = -kernel_radius; x <= kernel_radius; x++) {
      sum += gauss_kernel[hook(0, (x + kernel_radius) + (y + kernel_radius) * kernel_diameter)] * input[hook(2, min(width - 1, max(coord.x + x, 0)) + min(height - 1, max(coord.y + y, 0)) * width)];
    }
  }

  output[hook(3, coord.x + coord.y * width)] = sum;
}