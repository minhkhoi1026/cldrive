//{"bufferA":0,"bufferB":1,"flags":4,"result":2,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectorAdd(global int* bufferA, global int* bufferB, global int* result, const unsigned int size, local int* flags) {
  size_t id = get_global_id(0);
  if (id < size) {
    result[hook(2, id)] = bufferA[hook(0, id)] + bufferB[hook(1, id)];
  }
}