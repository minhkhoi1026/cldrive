//{"aBuffer":1,"bBuffer":2,"cBuffer":3,"k":0,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecsum(float k, global float* aBuffer, global float* bBuffer, global float* cBuffer, int size) {
  size_t globalId = get_global_id(0);

  if (globalId < size)
    cBuffer[hook(3, globalId)] = k * aBuffer[hook(1, globalId)] + bBuffer[hook(2, globalId)];
}