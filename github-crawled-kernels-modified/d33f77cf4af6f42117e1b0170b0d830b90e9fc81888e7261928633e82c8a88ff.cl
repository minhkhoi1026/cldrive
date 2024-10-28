//{"img_in":0,"img_out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerA = 0 | 4 | 0x10;
const sampler_t samplerB = 1 | 6 | 0x20;
kernel void floatToR(read_only image2d_t img_in, write_only image2d_t img_out) {
  const int2 pos = (int2)(get_global_id(0), get_global_id(1));
  float4 v = read_imagef(img_in, samplerA, pos);
  int r = (int)(v.x * 200.0f);
  int g = (int)(v.x * 56.0f);
  int b = (int)(v.x * 10.f);
  write_imageui(img_out, pos, (uint4)(r, g, b, 255));
}