//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sam_norm = 1 | 2 | 0x20;
const sampler_t sam_float = 2 | 0x20;
kernel void copy(read_only image2d_t src, write_only image2d_t dst) {
  int2 cds = (int2)(get_global_id(0), get_global_id(1));
  float2 cdsf = (float2)(get_global_id(0), get_global_id(1)) / (float2)(get_global_size(0) - 1, get_global_size(1) - 1);
  float4 a = read_imagef(src, sam_norm, cdsf);
  write_imagef(dst, cds, (float4)(a.xyz, 1));
}