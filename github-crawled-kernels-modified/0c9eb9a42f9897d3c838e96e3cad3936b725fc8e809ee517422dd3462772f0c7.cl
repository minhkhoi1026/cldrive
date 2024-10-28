//{"img_input":0,"img_output":1,"outputSwapMask":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClBinSwap(read_only image2d_t img_input, write_only image2d_t img_output) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  uint4 p = read_imageui(img_input, smp, (int2)(coords.x, coords.y));
  unsigned char result = 0;
  unsigned char mask = 1;
  unsigned char input = p.x;
  unsigned char outputSwapMask[32] = {
      0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01,
  };

  for (int i = 0; i < 8; i++) {
    if (input & mask) {
      result = result | outputSwapMask[hook(2, i)];
    }
    mask = mask << 1;
  }
  write_imageui(img_output, coords, result);
}