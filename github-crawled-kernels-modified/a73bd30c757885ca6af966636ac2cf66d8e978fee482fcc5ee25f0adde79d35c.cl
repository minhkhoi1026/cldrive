//{"img_input":0,"img_output":1,"thresh":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClBinThreshold(read_only image2d_t img_input, write_only image2d_t img_output, float thresh) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 2 | 0x10;

  uint4 result = 0;
  for (int bit = 0; bit < 8; bit++) {
    float4 p = read_imagef(img_input, smp, (int2)(8 * coords.x + bit, coords.y));
    uint4 result_bit;
    if (p.x >= thresh)
      result_bit.x = 1;
    else
      result_bit.x = 0;
    result += result_bit.x << bit;
  }
  write_imageui(img_output, coords, result);
}