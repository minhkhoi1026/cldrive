//{"image1":0,"image2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_copy(read_only image2d_t image1, write_only image2d_t image2) {
  const int xout = get_global_id(0);
  const int yout = get_global_id(1);
  const sampler_t sampler = 0 | 4 | 0x10;
  float4 pixel;

  pixel = read_imagef(image1, sampler, (int2)(xout, yout));
  write_imagef(image2, (int2)(xout, yout), pixel);
}