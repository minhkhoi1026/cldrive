//{"inCol":0,"outCol":1,"test":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t smpNorm = 1 | 4 | 0x20;
kernel void standardKernel(read_only image2d_t inCol, write_only image2d_t outCol, float test) {
  int2 target = (int2)(get_global_id(0), get_global_id(1));
  float2 targetNorm = convert_float2(target) / convert_float2((int2)(get_global_size(0), get_global_size(1)));

  float4 float3 = read_imagef(inCol, smpNorm, targetNorm);
  write_imagef(outCol, target, float3 * test);
}