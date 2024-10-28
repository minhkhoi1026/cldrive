//{"img_height":3,"img_in":0,"img_out":1,"img_width":2,"theta":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x20 | 4;
kernel void rotation(read_only image2d_t img_in, write_only image2d_t img_out, int img_width, int img_height, float theta) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float x0 = img_width / 2.0f;
  float y0 = img_height / 2.0f;

  int xprime = x - x0;
  int yprime = y - y0;

  float sintheta = sin(theta);
  float costheta = cos(theta);

  float2 pix_in;
  pix_in.x = xprime * costheta - yprime * sintheta + x0;
  pix_in.y = xprime * sintheta + yprime * costheta + y0;

  float value = read_imagef(img_in, sampler, pix_in).x;

  write_imagef(img_out, (int2)(x, y), (float4)(value, 0.f, 0.f, 0.f));
}