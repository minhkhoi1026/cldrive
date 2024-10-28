//{"in":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
extern int get_value(const global int* in);
kernel void test_linker(global int* out, const global int* in) {
  out[hook(0, get_global_id(0))] = get_value(in);
}