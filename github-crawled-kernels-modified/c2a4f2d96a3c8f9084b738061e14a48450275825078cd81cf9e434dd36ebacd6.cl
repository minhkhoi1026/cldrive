//{"curFrame":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void helloPixel(float curFrame, write_only image2d_t out) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  const int2 dim = {get_global_size(0), get_global_size(1)};
  float4 float3;

  float3.x = 1.0f;
  float3.y = sinpi(((pos.x + fmod(curFrame * 8, dim.x)) / dim.x) * 2.0f) / 2.0f + 0.5f;
  float3.z = sinpi(((pos.y + fmod(curFrame, dim.y)) / dim.y) * 2.0f) / 2.0f + 0.5f;
  float3.w = 0;
  write_imagef(out, pos, float3);
}