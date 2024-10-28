//{"buffer":3,"count":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global int* input, global int* output, const unsigned int count, local int* buffer) {
  unsigned int global_index_0 = get_global_id(0);
  unsigned int global_index_1 = get_global_id(1);
  int local_index = get_local_id(0);
  int local_size = get_local_size(0);
  if (global_index_0 < count) {
    int i = input[hook(0, global_index_0)];

    buffer[hook(3, local_index)] = input[hook(0, global_index_0)];
    for (int j = 0; j < count; j++) {
    }
  }
}