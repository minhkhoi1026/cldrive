//{"dest":3,"height":1,"src":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10 | 2;
kernel void RGB24_RGBAUint8(int width, int height, global uchar* src, write_only image2d_t dest) {
  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  ulong src_idx = (pos.y * width * 3) + (pos.x * 3);

  uchar red = src[hook(2, src_idx)];
  uchar green = src[hook(2, src_idx + 1)];
  uchar blue = src[hook(2, src_idx + 2)];

  uint4 pixel = (uint4)((unsigned int)red, (unsigned int)green, (unsigned int)blue, 255);

  write_imageui(dest, pos, pixel);
}