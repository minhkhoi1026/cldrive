//{"dest":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void f0(global unsigned int dest[]) {
  dest[hook(0, 0)] = 0;
}