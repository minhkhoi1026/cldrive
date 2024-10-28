//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float linear_to_gamma_2_2(float value) {
  if (value > 0.003130804954f)
    return 1.055f * native_powr(value, (1.0f / 2.4f)) - 0.055f;
  return 12.92f * value;
}

float gamma_2_2_to_linear(float value) {
  if (value > 0.04045f)
    return native_powr((value + 0.055f) / 1.055f, 2.4f);
  return value / 12.92f;
}

kernel void rgbau8_to_ycbcraf(global const uchar4* in, global float4* out) {
  int gid = get_global_id(0);
  float4 in_v = convert_float4(in[hook(0, gid)]) / 255.0f;
  float4 out_v;

  float4 rgb = (float4)(linear_to_gamma_2_2(in_v.x), linear_to_gamma_2_2(in_v.y), linear_to_gamma_2_2(in_v.z), 0.0f);

  out_v = (float4)(0.299f * rgb.x + 0.587f * rgb.y + 0.114f * rgb.z, -0.168736f * rgb.x - 0.331264f * rgb.y + 0.5f * rgb.z, 0.5f * rgb.x - 0.418688f * rgb.y - 0.081312f * rgb.z, in_v.w);
  out[hook(1, gid)] = out_v;
}