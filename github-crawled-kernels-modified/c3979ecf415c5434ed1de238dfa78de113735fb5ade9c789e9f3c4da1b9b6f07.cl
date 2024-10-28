//{"in":1,"in0":0,"in1":1,"offset":0,"out":2,"out0":3,"out1":4,"outTest":2}
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

kernel void test_add(global const uchar16* in0, global const ushort16* in1, global uchar16* outTest, global ushort16* out0, global int16* out1) {
  size_t id = get_global_id(0);
  *outTest = *in0;

  out0[hook(3, id)] = convert_ushort16(*in0);

  out0[hook(3, id + 2)] = *in1;

  *out1 = convert_int16(*in0) + convert_int16(*in1);
}