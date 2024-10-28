//{"offset":1,"res1":0,"value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MemoryManager_memset(global unsigned int* res1, unsigned int offset, unsigned int value) {
  int index = get_global_id(0) + offset;

  res1[hook(0, index)] = value;
}