//{"degree":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samp = 0 | 4 | 0x10;
kernel void affineTrans(read_only image2d_t in, write_only image2d_t out, const float degree) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int width = get_image_width(in);
  int height = get_image_height(in);

  float radian = radians(degree);

  int yc = height / 2;
  int xc = width / 2;
  int outY = y - yc;
  int outX = x - xc;

  float inY = outX * sin(radian) + outY * cos(radian);
  float inX = outX * cos(radian) - outY * sin(radian);

  float2 coordr = (float2)(inX + (float)xc, inY + (float)yc);
  float4 dstValue = read_imagef(in, samp, coordr);

  int2 coordw = (int2)(x, y);
  write_imagef(out, coordw, dstValue);
}