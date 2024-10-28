//{"b":0,"c":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Invert(global const char* b, global char* c) {
  int id = get_global_id(0);
  c[hook(1, id)] = 255 - b[hook(0, id)];
}