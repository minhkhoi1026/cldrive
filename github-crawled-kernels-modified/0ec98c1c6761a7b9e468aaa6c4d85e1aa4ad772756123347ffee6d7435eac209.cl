//{"a":0,"c":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void part1(global float* a, global float* c) {
  unsigned int i = get_global_id(0);

  c[hook(1, i)] = a[hook(0, i)] + a[hook(0, i)];
}