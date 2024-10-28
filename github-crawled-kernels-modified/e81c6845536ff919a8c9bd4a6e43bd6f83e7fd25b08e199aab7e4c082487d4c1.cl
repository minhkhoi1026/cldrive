//{"bar":1,"foo":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_load_float(global float* foo, global float* bar) {
  foo[hook(0, 0)] = __builtin_load_halff(bar);
}