//{"buffer":0,"kernel_offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void commands_aggregation(global unsigned int* buffer, const unsigned int kernel_offset) {
  const unsigned int id = get_global_id(0);
  const unsigned int size = get_global_size(0);
  const ulong number_of_iterations = 1000000;
  for (unsigned int i = 0; i < number_of_iterations; ++i) {
    buffer[hook(0, kernel_offset * size + id)]++;
  }
}