//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void root(global float4* a) {
  int i = get_global_id(0);
  a[hook(0, i)] = sqrt(a[hook(0, i)]);
}