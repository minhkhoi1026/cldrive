//{"img_input":0,"img_output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vglClCopy(read_only image2d_t img_input, write_only image2d_t img_output) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  const sampler_t smp = 0 | 4 | 0x10;
  float4 p = read_imagef(img_input, smp, coords);
  write_imagef(img_output, coords, p);
}