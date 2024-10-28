//{"in":1,"in2":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global float* out, global float* in, global int* in2) {
  out[hook(0, 0)] = __builtin_nanf("");
  __builtin_memcpy(out, in, 32);
  out[hook(0, 0)] = __builtin_frexpf(in[hook(1, 0)], in2);
}