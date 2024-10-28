//{"source":1,"target":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void neatStuff(global int* target, global int* source) {
  int id = get_global_id(0);
  target[hook(0, id)] = source[hook(1, id)] + id;
}