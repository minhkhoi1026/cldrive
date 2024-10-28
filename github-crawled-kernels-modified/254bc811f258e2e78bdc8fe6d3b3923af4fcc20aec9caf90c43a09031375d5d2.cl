//{"b":3,"batch_size":2,"c":4,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_batch(global int* input, global int* output, const unsigned int batch_size, local int* b, local int* c) {
  unsigned int gid_x = get_global_id(0);
  unsigned int gid_y = get_global_id(1);
  unsigned int start_index = 256 * gid_y;
  int i;
  if (gid_x == 0) {
    output[hook(1, start_index)] = input[hook(0, start_index)];
    for (i = 1; i < 256; i++) {
      output[hook(1, start_index + i)] = output[hook(1, start_index + i - 1)] + input[hook(0, start_index + i)];
    }
  }
}