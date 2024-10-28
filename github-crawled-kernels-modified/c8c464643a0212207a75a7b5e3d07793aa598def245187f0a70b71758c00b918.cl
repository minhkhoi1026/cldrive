//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sam_norm = 1 | 2 | 0x20;
const sampler_t sam_int = 2 | 0x10;
constant const int r = 2;
constant const int size = r * 2 + 1;
constant const float k[] = {0.0066460357f, 0.19422555f, 0.59825677f, 0.19422555f, 0.0066460357f};
float lumi(float3 v) {
  float3 k = (float3)(0.3f, 0.59f, 0.11f);
  return dot(v, k);
}
kernel void filter_old(read_only image2d_t src, write_only image2d_t dst) {
  int2 cds = (int2)(get_global_id(0), get_global_id(1));

  float2 px1 = 1.0f / (float2)(get_global_size(0) - 1, get_global_size(1) - 1);
  float2 coords = (float2)(get_global_id(0), get_global_id(1)) * px1;

  float2 diff = (1 / 8.0f) * px1;

  float4 a = read_imagef(src, sam_norm, coords + (float2)(-diff.x, -diff.y)) + read_imagef(src, sam_norm, coords + (float2)(-diff.x, +diff.y)) + read_imagef(src, sam_norm, coords + (float2)(diff.x, diff.y)) + read_imagef(src, sam_norm, coords + (float2)(+diff.x, -diff.y));

  float l = length(a.xyz / 4) / 3;
  float4 out = (float4)(l, l, l, 1);
  write_imagef(dst, cds, out);
}