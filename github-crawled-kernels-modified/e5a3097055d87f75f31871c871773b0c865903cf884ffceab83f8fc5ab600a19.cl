//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 Blend(float4 original, float4 shift, float alpha) {
  float4 blended = original * (1.0f - alpha) + shift * alpha;
  return blended;
}

kernel void xBlend(global uchar4* in, global uchar4* out) {
  const float4 original = convert_float4(in[hook(0, ((get_global_id(1)) * get_global_size(0) + (get_global_id(0))))]);
  const float4 shift = convert_float4(in[hook(0, ((get_global_id(1)) * get_global_size(0) + ((get_global_id(0) + get_global_size(0) / 2) % get_global_size(0))))]);
  const float4 result = Blend(original, shift, clamp(fabs(fma(-2.0f * get_global_id(0), 1.0f / (get_global_size(0) - 1.0f), 1.0f)), 0.0f, 1.0f));
  out[hook(1, ((get_global_id(1)) * get_global_size(0) + (get_global_id(0))))] = convert_uchar4(result);
}