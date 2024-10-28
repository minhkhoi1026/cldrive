//{"image_height":3,"image_width":2,"psum":0,"psum_per_pixel":4,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve2d_reduce(global float* psum, global unsigned char* result, unsigned long image_width, unsigned long image_height, unsigned long psum_per_pixel) {
  const unsigned int pixel = get_global_id(0);
  const unsigned int fid = get_global_id(1);
  const unsigned int offset = pixel - get_global_offset(0);
  const unsigned long image_size = image_width * image_height;

  if (pixel < image_size) {
    float sum = 0.0;
    for (unsigned int i = 0; i < psum_per_pixel; ++i) {
      sum += psum[hook(0, offset * psum_per_pixel + i)];
    }

    result[hook(1, pixel + fid * image_size)] = sum;
  }
}