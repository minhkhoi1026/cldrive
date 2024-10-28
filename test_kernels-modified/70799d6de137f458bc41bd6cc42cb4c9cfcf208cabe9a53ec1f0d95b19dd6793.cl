//{"a":0,"b":1,"n":3,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_floats(global const float* a, global const float* b, global float* out, int n) {
  int i = get_global_id(0);
  if (i >= n)
    return;

  out[hook(2, i)] = a[hook(0, i)] + b[hook(1, i)];
}