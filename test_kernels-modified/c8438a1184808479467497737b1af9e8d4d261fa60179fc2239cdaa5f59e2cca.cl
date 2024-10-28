//{"N":3,"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addition(global int* a, global int* b, global int* c, global int* N) {
  int id = get_global_id(0);
  c[hook(2, id)] = a[hook(0, id)] + b[hook(1, id)];
}