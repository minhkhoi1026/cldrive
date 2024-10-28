//{"dstNV":1,"srcNV":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_planar_total(read_only image2d_t srcNV, write_only image2d_t dstNV) {
  const sampler_t sampler = 0 | 0x10;
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  float4 float3 = read_imagef(srcNV, sampler, loc);
}