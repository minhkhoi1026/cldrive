//{"a":0,"n":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void floats_to_complex(global const float* a, global float* out, int n) {
  int i = get_global_id(0);
  if (i >= n)
    return;

  out[hook(1, 2 * i)] = a[hook(0, i)];
  out[hook(1, 2 * i + 1)] = 0;
}