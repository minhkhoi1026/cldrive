//{"input":0,"localSums":3,"mean":2,"partial_mean_sum":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mean_stddev(global const unsigned char* input, global float* partial_mean_sum, const float mean) {
  unsigned int local_id = get_local_id(0);
  unsigned int group_size = get_local_size(0);
  local float localSums[256];

  localSums[hook(3, local_id)] = (float)input[hook(0, get_global_id(0))];

  for (unsigned int stride = group_size / 2; stride > 0; stride /= 2) {
    if (local_id < stride) {
      barrier(0x01);
      if (stride == group_size / 2)
        localSums[hook(3, local_id)] = sqrt((localSums[hook(3, local_id)] - mean) * (localSums[hook(3, local_id)] - mean)) + sqrt((localSums[hook(3, local_id + stride)] - mean) * (localSums[hook(3, local_id + stride)] - mean));
      else
        localSums[hook(3, local_id)] += localSums[hook(3, local_id + stride)];
    }
    barrier(0x01);
  }
  if (local_id == 0)
    partial_mean_sum[hook(1, get_group_id(0))] = localSums[hook(3, 0)];
}