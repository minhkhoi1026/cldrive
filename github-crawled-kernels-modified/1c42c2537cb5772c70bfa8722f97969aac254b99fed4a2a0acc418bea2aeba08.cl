//{"img_out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerA = 0 | 4 | 0x10;
const sampler_t samplerB = 1 | 6 | 0x20;
kernel void reset(write_only image2d_t img_out) {
  write_imagef(img_out, (int2)(get_global_id(0), get_global_id(1)), (float4)(0, 0, 0, 0));
}