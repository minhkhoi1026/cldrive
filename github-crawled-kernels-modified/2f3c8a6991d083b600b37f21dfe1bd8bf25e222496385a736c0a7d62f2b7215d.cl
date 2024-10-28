//{"n":1,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecinit(global float* out, int n) {
  const int i = get_global_id(0);
  if (i < n)
    out[hook(0, i)] = (i + 1);
}