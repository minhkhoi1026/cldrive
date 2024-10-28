//{"img_input":0,"img_output":1,"outputSwapMask":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClNdBinSwap(global unsigned char* img_input, global unsigned char* img_output) {
  int coord = ((get_global_id(2) - get_global_offset(2)) * get_global_size(1) * get_global_size(0)) + ((get_global_id(1) - get_global_offset(1)) * get_global_size(0)) + (get_global_id(0) - get_global_offset(0));

  unsigned char result = 0;
  unsigned char mask = 1;
  unsigned char input = img_input[hook(0, coord)];
  unsigned char outputSwapMask[32] = {
      0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01,
  };

  for (int i = 0; i < 8; i++) {
    if (input & mask) {
      result = result | outputSwapMask[hook(2, i)];
    }
    mask = mask << 1;
  }
  img_output[hook(1, coord)] = result;
}