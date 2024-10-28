//{"dst0":2,"dst1":3,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_long_convert_double(global long* src0, global ulong* src1, global double* dst0, global double* dst1) {
  int i = get_global_id(0);

  double d = src0[hook(0, i)];
  dst0[hook(2, i)] = d;

  d = src1[hook(1, i)];
  dst1[hook(3, i)] = d;
}