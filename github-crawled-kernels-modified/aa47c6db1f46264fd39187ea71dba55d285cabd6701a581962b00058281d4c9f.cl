//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samin = 2 | 0x10;
float lumi(float3 v) {
  float3 k = (float3)(0.3f, 0.59f, 0.11f);
  return dot(v, k);
}

kernel void filter(read_only image2d_t src, write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 a = read_imagef(src, samin, coords);
  float la = lumi(a.xyz);
  write_imagef(dst, coords, (float4)(la, la, la, 1));
}