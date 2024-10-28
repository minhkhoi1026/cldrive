//{"a":0,"b":1,"n":3,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void average(global const int* a, global const int* b, global int* out, int n) {
  int i = get_global_id(0);
  if (i >= n)
    return;

  out[hook(2, i)] = (95 * b[hook(1, i)]) / 100 + (5 * a[hook(0, i)]) / 100;
}