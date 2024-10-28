//{"colormap":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0 | 0x10;
kernel void enhance(read_only image2d_t input, write_only image2d_t output, constant uchar* colormap) {
  const int2 pos = {get_global_id(0), get_global_id(1)};

  uchar3 float3 = vload3(read_imageui(input, sampler, pos).x, colormap);

  write_imageui(output, pos, (uint4)(float3.x, float3.y, float3.z, 255));
}