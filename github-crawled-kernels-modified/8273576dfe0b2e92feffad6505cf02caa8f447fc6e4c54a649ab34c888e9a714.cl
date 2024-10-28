//{"input":0,"localmaxs":3,"localmaxsLocation":4,"partial_max":1,"partial_max_location":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_loc(global const unsigned char* input, global unsigned char* partial_max, global unsigned char* partial_max_location) {
  unsigned int local_id = get_local_id(0);
  unsigned int group_size = get_local_size(0);
  local unsigned char localmaxs[256];
  local unsigned char localmaxsLocation[256];

  localmaxs[hook(3, local_id)] = input[hook(0, get_global_id(0))];
  localmaxsLocation[hook(4, local_id)] = get_global_id(0);

  for (unsigned int stride = group_size / 2; stride > 0; stride /= 2) {
    if (local_id < stride) {
      barrier(0x01);
      if (localmaxs[hook(3, local_id)] > localmaxs[hook(3, local_id + stride)]) {
        localmaxs[hook(3, local_id)] = localmaxs[hook(3, local_id + stride)];
        localmaxsLocation[hook(4, local_id)] = get_global_id(0) + stride;
      }
    }
    barrier(0x01);
  }
  if (local_id == 0) {
    partial_max[hook(1, get_group_id(0))] = localmaxs[hook(3, 0)];
    partial_max_location[hook(2, get_group_id(0))] = localmaxsLocation[hook(4, 0)];
  }
}