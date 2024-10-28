//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelUShort(ushort8 input, global ushort8* output) {
  output[hook(1, 0)] = input;
}