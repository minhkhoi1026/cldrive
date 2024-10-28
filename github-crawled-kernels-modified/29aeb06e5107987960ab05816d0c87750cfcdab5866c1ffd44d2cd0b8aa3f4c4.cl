//{"input":0,"localSums":2,"partialSums":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global const unsigned char* input, global long* partialSums) {
  unsigned int local_id = get_local_id(0);
  unsigned int group_size = get_local_size(0);
  local int localSums[256];

  localSums[hook(2, local_id)] = (long)input[hook(0, get_global_id(0))];

  for (unsigned int stride = group_size / 2; stride > 0; stride /= 2) {
    barrier(0x01);
    if (local_id < stride)
      localSums[hook(2, local_id)] += localSums[hook(2, local_id + stride)];
  }
  if (local_id == 0)
    partialSums[hook(1, get_group_id(0))] = localSums[hook(2, 0)];
}