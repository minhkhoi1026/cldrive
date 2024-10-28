//{"numValues":1,"values":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void determineNativeAccuracy(global float8* restrict values, int numValues) {
  for (int i = get_global_id(0); i < numValues; i += get_global_size(0)) {
    float v = values[hook(0, i)].s0;
    values[hook(0, i)] = (float8)(v, native_sqrt(v), native_rsqrt(v), native_recip(v), native_exp(v), native_log(v), 0.0f, 0.0f);
  }
}