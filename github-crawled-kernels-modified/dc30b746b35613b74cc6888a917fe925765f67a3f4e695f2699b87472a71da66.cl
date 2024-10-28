//{"source":0,"target":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x20;
kernel void glowthing(read_only image2d_t source, write_only image2d_t target) {
  float2 pos = {get_global_id(0), get_global_id(1)};
  float4 pixel = read_imagef(source, sampler, (float2)(pos.x + 0.5f, pos.y + 0.5f)) + read_imagef(source, sampler, (float2)(pos.x - 0.5f, pos.y + 0.5f)) + read_imagef(source, sampler, (float2)(pos.x + 0.5f, pos.y - 0.5f)) + read_imagef(source, sampler, (float2)(pos.x - 0.5f, pos.y - 0.5f));
  write_imagef(target, (int2)(pos.x, pos.y), pixel * 9.0f / 4.0f);
}