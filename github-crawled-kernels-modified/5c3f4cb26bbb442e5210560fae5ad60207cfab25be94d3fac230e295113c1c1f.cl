//{"dst":2,"src":0,"total":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sam_norm = 1 | 2 | 0x20;
const sampler_t sam_float = 2 | 0x20;
kernel void adjust(read_only image2d_t src, read_only image2d_t total, write_only image2d_t dst) {
  int2 cds = (int2)(get_global_id(0), get_global_id(1));
  float2 cdsf = (float2)(get_global_id(0), get_global_id(1));

  float2 off = read_imagef(total, sam_float, (float2)(0, 0)).xy * 2000;

  float4 out = read_imagef(src, sam_float, cdsf + off);

  write_imagef(dst, cds, out);
}