//{"dst":3,"pos":2,"size":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rotateCopy(constant float* src, int size, int pos, global float* dst) {
  const int index = get_global_id(0);

  int srcIndex = pos + index;

  if (srcIndex > size)
    srcIndex -= size;

  dst[hook(3, index)] = src[hook(0, srcIndex)];
}