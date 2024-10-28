//{"dest":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 2 | 0x10;
kernel void grayscale(read_only image2d_t src, write_only image2d_t dest) {
  int2 pixel = (int2)(get_global_id(0), get_global_id(1));
  float4 colour = read_imagef(src, sampler, pixel);

  float total = 0.0f;
  total += colour.x;
  total += colour.y;
  total += colour.z;
  total /= 3.0f;
  total = clamp(total, 0.0f, 1.0f);
  write_imagef(dest, pixel, (float4)(total, total, total, 1.0));
}