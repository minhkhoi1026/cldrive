//{"dst":0,"h":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct hop {
  int x, y;
};

kernel void compiler_argument_structure(global int* dst, struct hop h) {
  int id = (int)get_global_id(0);
  dst[hook(0, id)] = h.x + h.y;
}