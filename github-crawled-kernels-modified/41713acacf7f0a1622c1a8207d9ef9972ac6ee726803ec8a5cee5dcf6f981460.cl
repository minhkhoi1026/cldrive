//{"a":0,"b":1,"c":2,"iNumElements":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void s_vector_add(global const float* a, global const float* b, global float* c, int iNumElements) {
  int i = get_global_id(0);

  if (i < iNumElements) {
    c[hook(2, i)] = a[hook(0, i)] + b[hook(1, i)];
  }
}