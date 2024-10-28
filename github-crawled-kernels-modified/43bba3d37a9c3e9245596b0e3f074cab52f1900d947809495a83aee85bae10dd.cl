//{"count":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void memoryCheckInt(global int* input, global int* output, unsigned int count) {
  unsigned int i;
  for (i = 0; i < count; i++) {
    if (input[hook(0, i)] != 0)
      output[hook(1, 0)]++;
  }
}