//{"a":2,"b":3,"input":0,"need_inplace":4,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scan_hillis_steele(global float* input, global float* output, local float* a, local float* b, int need_inplace) {
  unsigned int gid = get_global_id(0);
  unsigned int lid = get_local_id(0);
  unsigned int block_size = get_local_size(0);

  a[hook(2, lid)] = b[hook(3, lid)] = input[hook(0, gid)];
  barrier(0x01);

  for (unsigned int s = 1; s < block_size; s <<= 1) {
    if (lid > (s - 1)) {
      b[hook(3, lid)] = a[hook(2, lid)] + a[hook(2, lid - s)];
    } else {
      b[hook(3, lid)] = a[hook(2, lid)];
    }
    barrier(0x01);
    {
      local int* tmp = a;
      a = b;
      b = tmp;
    };
  }

  if (need_inplace) {
    output[hook(1, gid)] = a[hook(2, lid)];
  } else {
    unsigned int group_id = get_group_id(0);
    if (lid == 255)
      output[hook(1, group_id)] = a[hook(2, lid)];
  }
}