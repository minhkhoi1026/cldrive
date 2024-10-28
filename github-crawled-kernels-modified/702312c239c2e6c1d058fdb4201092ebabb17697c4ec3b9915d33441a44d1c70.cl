//{"a":0,"b":1,"c":2,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecAdd(global double* a, global double* b, global double* c, const unsigned int n) {
  int id = get_global_id(0);

  if (id < n)
    c[hook(2, id)] = a[hook(0, id)] + b[hook(1, id)];
}