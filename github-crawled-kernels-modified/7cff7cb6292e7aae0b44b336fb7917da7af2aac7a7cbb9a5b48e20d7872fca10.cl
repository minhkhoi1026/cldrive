//{"height":2,"matrix":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Generate(global ulong* matrix, int width, int height) {
  int id = get_global_id(1) * 16 * width + get_global_id(0) * 16;
  matrix[hook(0, id)] = (ulong)(&(matrix[hook(0, id)]));
}