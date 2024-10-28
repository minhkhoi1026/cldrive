//{"in":0,"offset":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((work_group_size_hint(1, 1, 1))) void test_arithm(const float offset, constant const float16* in, global float16* out) {
  size_t id = get_global_id(0);
  float16 tmp = in[hook(0, id)] + offset;
  out[hook(1, id)] = tmp;
}

kernel void test_copy(global const int16* in, global int16* out) {
  size_t id = get_global_id(0);
  const int16 data = *in;
  out[hook(1, id)] = data;
  out[hook(1, id + 1)] = data;
}