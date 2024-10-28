//{"dest":3,"height":1,"src":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void Intensity8_RGBAUint8(int width, int height, global uchar* src, write_only image2d_t dest) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  ulong src_idx = pos.y * width + pos.x;

  uchar val = src[hook(2, src_idx)];

  uint4 pixel = (uint4)((unsigned int)val, (unsigned int)val, (unsigned int)val, 255);

  write_imageui(dest, pos, pixel);
}