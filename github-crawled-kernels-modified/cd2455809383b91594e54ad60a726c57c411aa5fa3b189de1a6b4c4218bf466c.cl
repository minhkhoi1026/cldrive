//{"a":0,"b":1,"c":2,"numElements":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectorAdd(global const float* a, global const float* b, global float* c, int numElements) {
  int iGID = get_global_id(0);

  if (iGID >= numElements) {
    return;
  }

  c[hook(2, iGID)] = a[hook(0, iGID)] + b[hook(1, iGID)];
}