//{"memory":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testShiftCL(global unsigned int* memory, unsigned int size) {
  memory[hook(0, get_global_id(0))] <<= size;
}