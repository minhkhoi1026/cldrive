//{"buffer":0,"length":1,"result":4,"resultIndex":5,"scratch":2,"scratchIndex":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void indexReduceMax(global float* buffer, const int length, local float* scratch, local int* scratchIndex, global float* result, global int* resultIndex) {
  int global_index = get_global_id(0);
  float accumulator = -1;
  int accumulatorIndex = -1;

  while (global_index < length) {
    float element = buffer[hook(0, global_index)];
    if (accumulator < element) {
      accumulator = element;
      accumulatorIndex = global_index;
    }
    global_index += get_global_size(0);
  }

  int local_index = get_local_id(0);
  scratch[hook(2, local_index)] = accumulator;
  scratchIndex[hook(3, local_index)] = accumulatorIndex;
  barrier(0x01);
  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (local_index < offset) {
      float other = scratch[hook(2, local_index + offset)];
      float mine = scratch[hook(2, local_index)];
      if (mine > other) {
        scratch[hook(2, local_index)] = mine;
        scratchIndex[hook(3, local_index)] = scratchIndex[hook(3, local_index)];
      } else {
        scratch[hook(2, local_index)] = other;
        scratchIndex[hook(3, local_index)] = scratchIndex[hook(3, local_index + offset)];
      }
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    result[hook(4, get_global_id(0))] = scratch[hook(2, 0)];
    resultIndex[hook(5, get_global_id(0))] = scratchIndex[hook(3, 0)];
  }
}