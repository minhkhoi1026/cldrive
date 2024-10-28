//{"buffer":0,"length":2,"result":3,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global float* buffer, local float* scratch, const int length, global float* result) {
  int global_index = get_global_id(0);

  if (global_index >= length)
    return;

  float accumulator = 0;
  while (global_index < length) {
    float element = buffer[hook(0, global_index)];
    accumulator += element;
    global_index += get_global_size(0);
  }

  int local_index = get_local_id(0);
  scratch[hook(1, local_index)] = accumulator;
  barrier(0x01);
  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (local_index < offset && local_index + offset < length) {
      float other = scratch[hook(1, local_index + offset)];
      float mine = scratch[hook(1, local_index)];
      scratch[hook(1, local_index)] = mine + other;
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    result[hook(3, get_group_id(0))] = scratch[hook(1, 0)];
  }
}