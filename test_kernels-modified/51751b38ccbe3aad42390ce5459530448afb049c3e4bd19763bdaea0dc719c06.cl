//{"buffer":0,"length":3,"result":4,"result_index":5,"scratch":1,"scratch_index":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global float* buffer, local float* scratch, local float* scratch_index, const int length, global float* result, global float* result_index) {
  int global_index = get_global_id(0);
  float accumulator = -(__builtin_inff());
  int index = -1;

  while (global_index < length) {
    float element = fabs(buffer[hook(0, global_index)]);
    accumulator = (accumulator > element) ? accumulator : element;
    index = (accumulator > element) ? index : global_index;
    global_index += get_global_size(0);
  }

  int local_index = get_local_id(0);
  scratch[hook(1, local_index)] = accumulator;
  scratch_index[hook(2, local_index)] = index;
  barrier(0x01);
  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (local_index < offset) {
      if (scratch[hook(1, local_index)] < scratch[hook(1, local_index + offset)]) {
        scratch[hook(1, local_index)] = scratch[hook(1, local_index + offset)];
        scratch_index[hook(2, local_index)] = scratch_index[hook(2, local_index + offset)];
      }
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    result[hook(4, get_group_id(0))] = scratch[hook(1, 0)];
    result_index[hook(5, get_group_id(0))] = scratch_index[hook(2, 0)];
  }
}