//{"a":0,"b":1,"c":2,"numElements":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VecAdd(global const int* a, global const int* b, global int* c, int numElements) {
  int GID = get_global_id(0);
  if (GID < numElements) {
    c[hook(2, GID)] = a[hook(0, GID)] + b[hook(1, numElements - GID - 1)];
  }
}