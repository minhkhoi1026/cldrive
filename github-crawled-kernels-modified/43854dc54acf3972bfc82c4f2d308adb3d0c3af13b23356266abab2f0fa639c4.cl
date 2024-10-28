//{"memoryA":1,"memoryB":2,"memoryC":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testMemCL(global unsigned int* memoryC, global const unsigned int* memoryA, global const unsigned int* memoryB) {
  size_t id = get_global_id(0);
  memoryC[hook(0, id)] = memoryA[hook(1, id)] + memoryB[hook(2, id)];
}