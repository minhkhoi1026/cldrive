//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void grayscale(read_only image2d_t src, write_only image2d_t dst) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  float4 float3 = read_imagef(src, sampler, coords);
  float3.xyz = (float3.x * 0.299f + float3.y * 0.587f + float3.z * 0.114f);
  write_imagef(dst, coords, float3);
}