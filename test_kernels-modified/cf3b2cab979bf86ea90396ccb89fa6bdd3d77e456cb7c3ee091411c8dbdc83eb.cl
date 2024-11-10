//{"buffer":0,"localBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void localmem(global unsigned int* buffer, local unsigned int* localBuffer) {
  buffer[hook(0, 0)] = 0xdeadbeef;
}