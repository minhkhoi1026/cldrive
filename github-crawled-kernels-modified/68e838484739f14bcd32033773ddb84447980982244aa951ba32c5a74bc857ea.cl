//{"dstImg":1,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void threshold(read_only image2d_t srcImg, write_only image2d_t dstImg) {
  const sampler_t smp = 0 | 2 | 0x10;
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  uint4 bgra = read_imageui(srcImg, smp, coord);

  if (bgra.x + bgra.y + bgra.z < 128 * 3) {
    bgra.x = 0;
    bgra.y = 0;
    bgra.z = 0;
  } else {
    bgra.x = 256;
    bgra.y = 256;
    bgra.z = 256;
  }

  write_imageui(dstImg, coord, bgra);
}