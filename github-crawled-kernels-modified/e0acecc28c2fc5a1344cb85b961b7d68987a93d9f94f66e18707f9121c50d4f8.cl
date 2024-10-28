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

kernel void rgbaf_to_yaf(global const float4* in, global float2* out) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float2 out_v;

  float luminance = in_v.x * (0.299) + in_v.y * (0.587) + in_v.z * (0.114);

  out_v.x = luminance;
  out_v.y = in_v.w;

  out[hook(1, gid)] = out_v;
}