//{"a":0,"b":1,"c":2,"iNumElements":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void DotProduct(global double* a, global double* b, global double* c, long iNumElements) {
  int iGID = get_global_id(0);

  if (iGID >= iNumElements)
    return;

  int iInOffset = iGID << 2;
  c[hook(2, iGID)] = a[hook(0, iInOffset)] * b[hook(1, iInOffset)] + a[hook(0, iInOffset + 1)] * b[hook(1, iInOffset + 1)] + a[hook(0, iInOffset + 2)] * b[hook(1, iInOffset + 2)] + a[hook(0, iInOffset + 3)] * b[hook(1, iInOffset + 3)];
}