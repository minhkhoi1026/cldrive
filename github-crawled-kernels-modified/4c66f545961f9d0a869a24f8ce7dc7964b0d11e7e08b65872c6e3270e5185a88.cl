//{"tabSize":1,"wy":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void myKernel(global int* wy, int tabSize) {
  int id = get_global_id(0);
  if (id > tabSize)
    return;

  wy[hook(0, id)] = id;
}