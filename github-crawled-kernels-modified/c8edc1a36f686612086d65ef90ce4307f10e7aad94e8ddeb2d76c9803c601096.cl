//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global unsigned int* a) {
  a[hook(0, 0)] = get_local_size(0);
  a[hook(0, 1)] = get_local_size(1);
  a[hook(0, 2)] = get_local_size(2);
  a[hook(0, 3)] = get_local_size(3);
}