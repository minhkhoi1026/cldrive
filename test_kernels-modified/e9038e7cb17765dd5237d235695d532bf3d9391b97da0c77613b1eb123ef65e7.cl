//{"count":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
;
kernel void plus_1d(global int* input, global int* output, const unsigned int count) {
  unsigned int global_index = get_global_id(0);
  if (global_index < count) {
    for (int i = 0; i < 1024 * 1024 * 64; i++) {
      output[hook(1, global_index)] = input[hook(0, global_index)] + input[hook(0, global_index)];
    }
  }
}