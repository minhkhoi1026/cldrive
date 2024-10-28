//{"a":0,"b":1,"c":2,"numElements":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void VectorAdd(global const float8* a, global const float8* b, global float8* c, int numElements) {
  int iGID = get_global_id(0);
  if (iGID >= numElements)
    return;

  float8 aGID = a[hook(0, iGID)];
  float8 bGID = b[hook(1, iGID)];

  float8 result = aGID + bGID;

  c[hook(2, iGID)] = result;
}