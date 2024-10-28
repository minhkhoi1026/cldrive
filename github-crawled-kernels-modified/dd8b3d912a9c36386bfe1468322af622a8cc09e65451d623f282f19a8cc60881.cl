//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_uint3_unaligned_copy(global unsigned int* src, global unsigned int* dst) {
  const int id = (int)get_global_id(0);
  const uint3 from = vload3(id, src);
  vstore3(from, id, dst);
}