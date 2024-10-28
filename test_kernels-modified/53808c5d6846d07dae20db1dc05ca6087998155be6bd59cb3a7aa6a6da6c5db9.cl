//{"a":0,"b":1,"c":2,"iNumElements":3,"indexDst":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectorAdd(global const float* a, global const float* b, global float* c, int iNumElements, global unsigned int* indexDst) {
  int iGID = get_global_id(0);
  c[hook(2, iGID)] = 12.0f;

  if (iGID % 3 == 0) {
    indexDst[hook(4, iGID)] = iGID / 3;
    indexDst[hook(4, iGID + 1)] = iGID / 3;
    indexDst[hook(4, iGID + 2)] = iGID / 3;
  }
}