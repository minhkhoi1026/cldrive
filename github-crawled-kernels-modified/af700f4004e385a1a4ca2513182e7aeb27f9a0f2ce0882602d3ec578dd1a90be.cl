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

kernel void yu8_to_yf(global const uchar* in, global float* out) {
  int gid = get_global_id(0);
  float in_v = convert_float(in[hook(0, gid)]) / 255.0f;
  float out_v;
  out_v = in_v;
  out[hook(1, gid)] = out_v;
}