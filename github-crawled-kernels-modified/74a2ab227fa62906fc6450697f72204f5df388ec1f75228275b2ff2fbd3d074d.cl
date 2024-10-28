//{"dst":1,"k":2,"src":0}
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
kernel void filter_v(read_only image2d_t src, write_only image2d_t dst) {
  int2 cds = (int2)(get_global_id(0), get_global_id(1));

  float l = 0;
  for (int i = 0; i < size; ++i) {
    float4 a = read_imagef(src, sam_int, (int2)(cds.x, cds.y * 2 + i - r));
    l += lumi(a.xyz) * (k[hook(2, i)]);
  }

  float4 out = (float4)(l, l, l, 1);
  write_imagef(dst, cds, out);
}