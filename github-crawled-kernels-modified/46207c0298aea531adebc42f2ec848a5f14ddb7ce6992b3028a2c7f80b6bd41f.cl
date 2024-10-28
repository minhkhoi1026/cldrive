//{"grid":0,"num_elements":2,"result":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sumGlobalMemory(global const float* grid, global float* result, int const num_elements) {
  int global_id = get_global_id(0);
  int global_size = get_global_size(0);
  int work_per_thread = (num_elements / global_size) + 1;

  if (global_id >= num_elements)
    return;

  int offset = 0;
  offset = global_id * work_per_thread;

  result[hook(1, global_id)] = 0;
  for (int i = 0; i < work_per_thread; ++i) {
    if (offset + i < num_elements) {
      result[hook(1, global_id)] += grid[hook(0, offset + i)];
    }
  }
}