//{"in0":0,"in1":1,"in2":2,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_tmu_loads(const global int16* in0, const global int16* in1, const global int16* in2, global int16* out) {
  unsigned lid = get_local_id(0);
  out[hook(3, lid)] = in0[hook(0, lid)] + in1[hook(1, lid)] + in2[hook(2, lid)];

  int16 a = in0[hook(0, 16)];
  int16 b = in0[hook(0, 17)];
  int16 c = in0[hook(0, 18)];
  int16 d = in0[hook(0, 19)];
  int16 e = in1[hook(1, 16)];
  int16 f = in1[hook(1, 17)];
  int16 g = in1[hook(1, 18)];
  int16 h = in1[hook(1, 19)];
  int16 i = in2[hook(2, 16)];
  int16 k = in2[hook(2, 17)];
  int16 l = in2[hook(2, 18)];
  int16 m = in2[hook(2, 19)];
  out[hook(3, 16 + lid)] = a + b + c + d + e + f + g + h + i + k + l + m;
}