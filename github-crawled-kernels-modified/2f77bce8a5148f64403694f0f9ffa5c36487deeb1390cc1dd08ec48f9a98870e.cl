//{"dest":1,"source":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_step_type(global char* source, global int* dest) {
  int tid = get_global_id(0);
  dest[hook(1, tid)] = vec_step(char);
}