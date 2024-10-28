//{"((const __global char3 *)in)":3,"in":0,"offset":0,"out":1}
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

kernel void test_vector_load(const global char* in, global char3* out) {
  const uchar offset = 5;
  char3 tmp0 = vload3(offset, in);
  char3 tmp1 = ((const global char3*)in)[hook(3, offset)];
  char3 tmp2 = *((const global char3*)(in + offset * 3));
  char3 tmp3 = (char3)(in[hook(0, offset * 3)], in[hook(0, offset * 3 + 1)], in[hook(0, offset * 3 + 2)]);
  char3 tmp4 = *((const global char3*)(&in[hook(0, offset * 3)]));
  out[hook(1, 0)] = tmp0;
  out[hook(1, 1)] = tmp1;
  out[hook(1, 2)] = tmp2;
  out[hook(1, 3)] = tmp3;
  out[hook(1, 4)] = tmp4;
}