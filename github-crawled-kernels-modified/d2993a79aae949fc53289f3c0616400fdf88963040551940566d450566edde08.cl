//{"buffer":0,"length":2,"offset":4,"result":3,"scratch":1,"step":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reduce_NONE_MUL(global float* buffer, local float* scratch, const int length, global float* result, const int offset, const int step) {
  int global_index = get_global_id(0);
  float accumulator = 1;
  while (global_index < length) {
    float a = buffer[hook(0, offset + step * global_index)];
    float b = accumulator;
    accumulator = a * b;
    global_index += get_global_size(0);
  }
  int local_index = get_local_id(0);
  scratch[hook(1, local_index)] = accumulator;
  barrier(0x01);
  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (local_index < offset) {
      float a = scratch[hook(1, local_index + offset)];
      float b = scratch[hook(1, local_index)];
      scratch[hook(1, local_index)] = a * b;
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    result[hook(3, get_group_id(0))] = scratch[hook(1, 0)];
  }
}