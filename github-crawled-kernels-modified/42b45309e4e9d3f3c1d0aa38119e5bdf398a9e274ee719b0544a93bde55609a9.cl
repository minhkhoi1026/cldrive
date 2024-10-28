//{"a":0,"b":1,"c":2,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global float* restrict a, global float* restrict b, global float* restrict c, global float* restrict d) {
  int i = get_global_id(0);
  c[hook(2, i)] = a[hook(0, i)] + b[hook(1, i)];
  d[hook(3, i)] += c[hook(2, i)];
}