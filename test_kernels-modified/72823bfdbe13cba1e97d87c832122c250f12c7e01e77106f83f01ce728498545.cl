//{"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void atomic(global int* x) {
  local int a, b;

  a = 0;
  b = 0;

  a++;

  atomic_inc(&b);

  x[hook(0, 0)] = a;
  x[hook(0, 1)] = b;
}