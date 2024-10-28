//{"X":0,"Y":1,"kernel_height":10,"kernel_width":9,"maps":4,"pad_height":14,"pad_width":13,"samples":5,"source_height":3,"source_width":2,"stride_height":12,"stride_width":11,"target_height":7,"target_maps":8,"target_width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void COL2IM(global float* X, global float* Y, int source_width, int source_height, int maps, int samples, int target_width, int target_height, int target_maps, int kernel_width, int kernel_height, int stride_width, int stride_height, int pad_width, int pad_height) {
  const int source_oelement = get_global_id(0);
  const int source_map = get_global_id(1);
  const int sample = get_global_id(2);

  const int iy = source_oelement / source_width;
  const int ix = source_oelement % source_width;

  float sum = 0;
  for (int ky = 0; ky < kernel_height; ky++) {
    const int oy = (pad_height + iy - ky) / stride_height;
    if (oy >= 0 && oy < target_height && ((pad_height + iy - ky) % stride_height == 0)) {
      for (int kx = 0; kx < kernel_width; kx++) {
        const int ox = (pad_width + ix - kx) / stride_width;
        if (ox >= 0 && ox < target_width && ((pad_width + ix - kx) % stride_width == 0)) {
          const int target_map = (kernel_width * kernel_height) * source_map + (kernel_width * ky) + kx;

          sum += Y[hook(1, (target_map * samples * target_width * target_height) + (sample * target_height + oy) * target_width + ox)];
        }
      }
    }
  }

  X[hook(0, (sample * maps * source_width * source_height) + (source_map * source_width * source_height) + source_oelement)] = sum;
}