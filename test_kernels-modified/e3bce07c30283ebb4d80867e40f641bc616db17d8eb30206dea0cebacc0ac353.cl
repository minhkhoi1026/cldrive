//{"buffer":0,"length":2,"result":3,"scratch":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global float2* buffer, local float2* scratch, const int length, global float2* result) {
  int global_index = get_global_id(0);
  float2 accumulator = {-1, -1};

  while (global_index < length) {
    float2 element = buffer[hook(0, global_index)];
    accumulator = (accumulator.x > element.x) ? accumulator : element;
    global_index += get_global_size(0);
  }

  int local_index = get_local_id(0);
  scratch[hook(1, local_index)] = accumulator;
  barrier(0x01);
  for (int offset = get_local_size(0) / 2; offset > 0; offset >>= 1) {
    if (local_index < offset) {
      float2 other = scratch[hook(1, local_index + offset)];
      float2 mine = scratch[hook(1, local_index)];
      scratch[hook(1, local_index)] = (mine.x > other.x) ? mine : other;
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    result[hook(3, get_group_id(0))] = scratch[hook(1, 0)];
  }
}