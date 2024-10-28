//{"accel":0,"len1":1,"len2":2,"sdata":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce(global float4* accel, const unsigned int len1, const unsigned int len2, local float4* sdata) {
  unsigned int global_i = get_global_id(0);
  unsigned int global_j = get_global_id(1);

  unsigned int gid = global_i * len2 + global_j;

  unsigned int local_i = get_local_id(0);
  unsigned int local_j = get_local_id(1);

  unsigned int tid = local_i * get_local_size(1) + local_j;

  if (global_i < len1 && global_j < len2) {
    sdata[hook(3, tid)] = accel[hook(0, gid)];
  } else {
    sdata[hook(3, tid)] = (float4)(0.0, 0.0, 0.0, 0.0);
  }

  barrier(0x01);

  for (unsigned int s = get_local_size(1) / 2; s > 0; s >>= 1) {
    if (local_j < s && local_j + s < get_local_size(1)) {
      sdata[hook(3, tid)] += sdata[hook(3, tid + s)];
    }
    barrier(0x01);
  }

  if (local_j == 0) {
    unsigned int idx = get_group_id(0) * get_num_groups(1) + get_group_id(1);
    accel[hook(0, idx)] = sdata[hook(3, local_j)];
  }
}