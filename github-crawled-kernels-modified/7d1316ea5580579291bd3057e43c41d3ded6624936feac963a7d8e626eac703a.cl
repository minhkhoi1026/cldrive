//{"dstImg":1,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void brightness(read_only image2d_t srcImg, write_only image2d_t dstImg) {
  const sampler_t smp = 0 | 2 | 0x10;
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  uint4 bgra = read_imageui(srcImg, smp, coord);

  bgra.x += 100;
  bgra.y += 100;
  bgra.z += 100;
  bgra.w += 100;

  write_imageui(dstImg, coord, bgra);
}