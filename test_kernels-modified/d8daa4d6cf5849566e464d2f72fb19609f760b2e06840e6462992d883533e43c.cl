//{"b":2,"c":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_1c(global int* input, global int* output, local int* b, local int* c) {
  unsigned int gid = get_global_id(0);
  int i;
  if (gid == 0) {
    output[hook(1, 0)] = input[hook(0, 0)];
    output[hook(1, 256)] = input[hook(0, 256)];
    output[hook(1, 512)] = output[hook(1, 512)];
    for (i = 1; i < 256; i++) {
      output[hook(1, i)] = output[hook(1, i - 1)] + input[hook(0, i)];
      output[hook(1, i + 256)] = output[hook(1, 256 + i - 1)] + input[hook(0, 256 + i)];
      output[hook(1, i + 512)] = output[hook(1, 512 + i - 1)] + input[hook(0, 512 + i)];
    }
  }
}