//{"dt":4,"h":6,"img_in":0,"img_out":1,"u":2,"v":3,"w":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t samplerA = 0 | 4 | 0x10;
const sampler_t samplerB = 1 | 6 | 0x20;
kernel void advect_circular(read_only image2d_t img_in, write_only image2d_t img_out, read_only image2d_t u, read_only image2d_t v, float dt, int w, int h) {
  const int2 pos = (int2)(get_global_id(0), get_global_id(1));
  const float2 size = (float2)((float)w, (float)h);
  const float2 dt0 = dt * (float2)(w, h);
  const float2 pos_norm = (float2)(1.0f + pos.x, 1.0f + pos.y) / size;
  float4 inputU = read_imagef(u, samplerB, pos_norm);
  float4 inputV = read_imagef(v, samplerB, pos_norm);
  float2 velocity = (float2)(inputU.x, inputV.x);
  float2 dpos = (float2)(pos.x, pos.y) - dt0 * velocity.xy;

  int2 vi = (int2)(dpos.x, dpos.y);
  float2 vf = dpos / size;
  float4 input00 = read_imagef(img_in, samplerB, (float2)(vf.x, vf.y));
  float4 input01 = read_imagef(img_in, samplerB, (float2)(vf.x, vf.y + 1.0f));
  float4 input10 = read_imagef(img_in, samplerB, (float2)(vf.x + 1.0f, vf.y));
  float4 input11 = read_imagef(img_in, samplerB, (float2)(vf.x + 1.0f, vf.y + 1.0f));
  float4 s;
  s.zw = dpos - (float2)(vi.x, vi.y);
  s.xy = 1 - s.zw;
  float value = s.x * (s.y * input00.x + s.w * input01.x) + s.z * (s.y * input10.x + s.w * input11.x);
  write_imagef(img_out, pos, (float4)(value, 0, 0, 0));
}