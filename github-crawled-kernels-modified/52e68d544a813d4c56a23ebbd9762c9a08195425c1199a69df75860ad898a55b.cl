//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sam_int = 2 | 0x10;
const sampler_t sam_norm = 1 | 2 | 0x20;
const sampler_t sam_linear = 2 | 0x20;
float lumii(float3 v) {
  float3 k = (float3)(0.3f, 0.59f, 0.11f);
  return dot(v, k);
}
float lumi(image2d_t srci, int2 coords) {
  float4 col = read_imagef(srci, sam_int, coords);
  return lumii(col.xyz);
}
kernel void preprocess(read_only image2d_t src, write_only image2d_t dst) {
  int2 cds = (int2)(get_global_id(0), get_global_id(1));
  float v = lumi(src, cds);
  float ix = lumi(src, cds + (int2)(1, 0)) - lumi(src, cds + (int2)(-1, 0));
  float iy = lumi(src, cds + (int2)(0, 1)) - lumi(src, cds + (int2)(0, -1));
  write_imagef(dst, cds, (float4)(ix, iy, v, 1));
}