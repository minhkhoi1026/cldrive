//{"in":0,"out":1,"ratio":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x20;
kernel void bilinearResample(read_only image2d_t in, write_only image2d_t out, int ratio) {
  int2 gId = (int2)(get_global_id(0), get_global_id(1));

  float4 float3 = read_imagef(in, sampler, gId * ratio);
  write_imagef(out, gId, float3);
}