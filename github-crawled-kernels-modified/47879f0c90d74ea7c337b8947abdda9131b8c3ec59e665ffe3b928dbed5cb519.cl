//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sam_norm = 1 | 2 | 0x20;
const sampler_t sam_float = 2 | 0x20;
kernel void copy2array(read_only image2d_t src, global float* dst) {
  int2 cds = (int2)(get_global_id(0), get_global_id(1));
  float2 cdsf = (float2)(get_global_id(0), get_global_id(1)) / (float2)(get_global_size(0) - 1, get_global_size(1) - 1);
  float4 a = read_imagef(src, sam_norm, cdsf);
  int off = cds.y * get_global_size(0) + cds.x;
  dst[hook(1, off * 3)] = a.x;
  dst[hook(1, off * 3 + 1)] = a.y;
  dst[hook(1, off * 3 + 2)] = a.x;
}