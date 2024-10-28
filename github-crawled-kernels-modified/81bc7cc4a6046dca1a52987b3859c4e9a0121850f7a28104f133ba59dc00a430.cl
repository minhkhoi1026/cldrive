//{"in":1,"in1":0,"in2":1,"offset":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((work_group_size_hint(1, 1, 1))) void test_arithm(const float offset, constant const float16* in, global float16* out) {
  size_t id = get_global_id(0);
  float16 tmp = in[hook(1, id)] + offset;
  out[hook(2, id)] = tmp;
}

kernel void test_param(const uchar16 in1, const int4 in2, global int4* out) {
  *out = in2 + __builtin_astype((in1), int4);
}