//{"dest":1,"length":3,"src":0,"tmp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global float* src, global float* dest, local float* tmp, int length) {
  int global_index = get_global_id(0);
  float accumulator = 0.f;

  while (global_index < length) {
    float element = src[hook(0, global_index)];
    accumulator += element;
    global_index += get_global_size(0);
  }

  int local_index = get_local_id(0);
  tmp[hook(2, local_index)] = accumulator;
  barrier(0x01);
  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (local_index < offset) {
      float other = tmp[hook(2, local_index + offset)];
      float mine = tmp[hook(2, local_index)];
      tmp[hook(2, local_index)] = mine + other;
    }
    barrier(0x01);
  }
  if (local_index == 0) {
    dest[hook(1, get_group_id(0))] = tmp[hook(2, 0)];
  }
}