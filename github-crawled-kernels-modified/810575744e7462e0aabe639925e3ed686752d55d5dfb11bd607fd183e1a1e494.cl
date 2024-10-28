//{"input":0,"localMins":3,"localMinsLocation":4,"partial_min":1,"partial_min_location":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void min_loc(global const unsigned char* input, global unsigned char* partial_min, global unsigned char* partial_min_location) {
  unsigned int local_id = get_local_id(0);
  unsigned int group_size = get_local_size(0);
  local unsigned char localMins[256];
  local unsigned char localMinsLocation[256];

  localMins[hook(3, local_id)] = input[hook(0, get_global_id(0))];
  localMinsLocation[hook(4, local_id)] = get_global_id(0);

  for (unsigned int stride = group_size / 2; stride > 0; stride /= 2) {
    if (local_id < stride) {
      barrier(0x01);
      if (localMins[hook(3, local_id)] > localMins[hook(3, local_id + stride)]) {
        localMins[hook(3, local_id)] = localMins[hook(3, local_id + stride)];
        localMinsLocation[hook(4, local_id)] = get_global_id(0) + stride;
      }
    }
    barrier(0x01);
  }
  if (local_id == 0) {
    partial_min[hook(1, get_group_id(0))] = localMins[hook(3, 0)];
    partial_min_location[hook(2, get_group_id(0))] = localMinsLocation[hook(4, 0)];
  }
}