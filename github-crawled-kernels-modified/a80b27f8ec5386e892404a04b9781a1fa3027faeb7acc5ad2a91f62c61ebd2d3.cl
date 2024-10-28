//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float linear_to_gamma_2_2(float value);
float gamma_2_2_to_linear(float value);
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

kernel void yf_to_ragabaf(global const float* in, global float4* out) {
  int gid = get_global_id(0);
  float y = in[hook(0, gid)];
  float4 out_v = (float4)(y, y, y, 1.0f);

  out[hook(1, gid)] = out_v;
}