//{"buffer1":0,"buffer2":1,"length":3,"offset1":5,"offset2":7,"result":4,"scratch":2,"step1":6,"step2":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reduce2_SUB_ADD(global float* buffer1, global float* buffer2, local float* scratch, const int length, global float* result, const int offset1, const int step1, const int offset2, const int step2) {
  int global_index = get_global_id(0);
  float accumulator = 0;
  while (global_index < length) {
    float a = buffer1[hook(0, offset1 + step1 * global_index)];
    float b = buffer2[hook(1, offset2 + step2 * global_index)];
    float elem = a - b;
    a = elem;
    b = accumulator;
    accumulator = a + b;
    global_index += get_global_size(0);
  }
  int local_index = get_local_id(0);
  scratch[hook(2, local_index)] = accumulator;
  barrier(0x01);
  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (local_index < offset) {
      float a = scratch[hook(2, local_index + offset)];
      float b = scratch[hook(2, local_index)];
      scratch[hook(2, local_index)] = a + b;
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    result[hook(4, get_group_id(0))] = scratch[hook(2, 0)];
  }
}