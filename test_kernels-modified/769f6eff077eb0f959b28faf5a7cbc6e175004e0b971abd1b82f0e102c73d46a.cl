//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_sfu(global const float16* in, global float16* out) {
  float16 val = *in;
  out[hook(1, 0)] = native_recip(val);
  out[hook(1, 1)] = native_rsqrt(val);
  out[hook(1, 2)] = native_exp2(val);
  out[hook(1, 3)] = native_log2(val);
}