//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sam_norm = 1 | 2 | 0x20;
const sampler_t sam_float = 2 | 0x20;
kernel void clear(write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  write_imagef(dst, coords, (float4)(0, 0, 0, 1));
}