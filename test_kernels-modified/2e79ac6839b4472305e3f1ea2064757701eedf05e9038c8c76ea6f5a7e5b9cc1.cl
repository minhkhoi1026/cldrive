//{"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_insert_to_constant(global int4* dst) {
  int4 value = (int4)(0, 1, 2, 3);
  value.z = get_global_id(0);
  dst[hook(0, get_global_id(0))] = value;
}