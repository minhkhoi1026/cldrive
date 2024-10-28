//{"s":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dummy(global int* restrict s) {
  s[hook(0, get_global_id(0))] = get_global_id(0);
}