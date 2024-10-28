//{"dst":0,"h":1,"h.x":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct hop {
  int a, x[16];
};

kernel void compiler_argument_structure_indirect(global int* dst, struct hop h) {
  int id = (int)get_global_id(0);
  dst[hook(0, id)] = h.x[hook(2, get_local_id(0))];
}