//{"max_iterations":5,"output_image":0,"x_max":2,"x_min":1,"y_max":4,"y_min":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandelbrot(write_only image2d_t output_image, const double x_min, const double x_max, const double y_min, const double y_max, const unsigned int max_iterations) {
  double x0 = ((double)get_global_id(0) / (double)get_global_size(0)) * (x_max - x_min) + x_min;
  double y0 = ((double)get_global_id(1) / (double)get_global_size(1)) * (y_max - y_min) + y_min;

  double x = 0.0;
  double y = 0.0;
  unsigned int iteration = 0;
  double temp = 0.0;

  while ((x * x + y * y < 2.0 * 2.0) && (iteration < max_iterations)) {
    temp = x * x - y * y + x0;
    y = 2.0 * x * y + y0;
    x = temp;
    iteration = iteration + 1;
  }

  double quotient = (double)iteration / (double)max_iterations;

  write_imagef(output_image, (int2)(get_global_id(0), get_global_id(1)), (float4)(0.5 * sin(6.283185307179586476925286766559 * quotient - 3.1415926535897932384626433832795) + 0.5, 0.5 * sin(6.283185307179586476925286766559 * quotient - 1.5707963267948966192313216916398) + 0.5, 0.5 * sin(6.283185307179586476925286766559 * quotient) + 0.5, 1.0));
}