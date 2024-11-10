//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernelULong(ulong4 input, global ulong4* output) {
  output[hook(1, 0)] = input + 4294967297;
}