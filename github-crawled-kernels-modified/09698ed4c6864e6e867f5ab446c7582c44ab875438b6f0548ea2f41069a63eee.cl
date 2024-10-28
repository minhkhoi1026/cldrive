//{"in":0,"offset":1,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) __attribute__((reqd_work_group_size(1, 1, 1))) kernel void test_vector(global const float* in, const int offset, global float* out) {
  float16 tmp = vload16(offset, in);
  vstore16(tmp, offset, out);
  int i = 1;
  out[hook(2, i++)] = vec_step(in[hook(0, 0)]);
  out[hook(2, i++)] = (shuffle(tmp, (uint2)(0))).y;
  out[hook(2, i++)] = (shuffle2(tmp, in[hook(0, 0)], (uint4)(4, 2, 1, 8))).w;
  float4 tmp1 = tmp.s9ab4;
  tmp1.s31 = tmp.s57;
  vstore4(tmp1, 20, out);
}