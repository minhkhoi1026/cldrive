//{"dt":4,"h":6,"img_in":0,"img_out":1,"u":2,"v":3,"w":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerA = 0 | 4 | 0x10;
const sampler_t samplerB = 1 | 6 | 0x20;
kernel void advect(read_only image2d_t img_in, write_only image2d_t img_out, read_only image2d_t u, read_only image2d_t v, float dt, int w, int h) {
  const int2 pos = (int2)(get_global_id(0), get_global_id(1));

  const float2 dt0 = dt * (float2)(w, h);
  float4 inputU = read_imagef(u, samplerA, pos);
  float4 inputV = read_imagef(v, samplerA, pos);
  float2 velocity = (float2)(inputU.x, inputV.x);
  float2 dpos = (float2)(pos.x, pos.y) - dt0 * velocity.xy;
  clamp(dpos.x, 0.5f, w + 0.5f);
  clamp(dpos.y, 0.5f, h + 0.5f);
  int2 vi = (int2)(dpos.x, dpos.y);
  float4 input00 = read_imagef(img_in, samplerA, (int2)(vi.x, vi.y));
  float4 input01 = read_imagef(img_in, samplerA, (int2)(vi.x, vi.y + 1));
  float4 input10 = read_imagef(img_in, samplerA, (int2)(vi.x + 1, vi.y));
  float4 input11 = read_imagef(img_in, samplerA, (int2)(vi.x + 1, vi.y + 1));
  float4 s;
  s.zw = dpos - (float2)(vi.x, vi.y);
  s.xy = 1 - s.zw;
  float value = s.x * (s.y * input00.x + s.w * input01.x) + s.z * (s.y * input10.x + s.w * input11.x);
  write_imagef(img_out, pos, (float4)(value, 0, 0, 0));
}