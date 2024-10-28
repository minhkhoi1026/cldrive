//{"a":0,"iNumElements":2,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global int* a, int value, int iNumElements) {
  int iGID = get_global_id(0);
  if (iGID >= iNumElements) {
    return;
  }
  a[hook(0, iGID)] += value;
}