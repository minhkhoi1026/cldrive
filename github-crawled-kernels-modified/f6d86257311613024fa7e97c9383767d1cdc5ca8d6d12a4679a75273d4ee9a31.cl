//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void loop1(global float* a) {
  int id = get_local_id(0);
  a[hook(0, id)] = a[hook(0, id)] * 2;
}