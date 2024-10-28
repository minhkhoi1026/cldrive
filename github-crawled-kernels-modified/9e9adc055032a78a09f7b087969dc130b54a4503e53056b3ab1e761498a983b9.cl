//{"data":0,"output":2,"partial_sums":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduction_scalar(global float* data, local float* partial_sums, global float* output) {
  int lid = get_local_id(0);
  int group_size = get_local_size(0);

  partial_sums[hook(1, lid)] = data[hook(0, get_global_id(0))];
  barrier(0x01);

  for (int i = group_size / 2; i > 0; i >>= 1) {
    if (lid < i) {
      partial_sums[hook(1, lid)] += partial_sums[hook(1, lid + i)];
    }
    barrier(0x01);
  }

  if (lid == 0) {
    output[hook(2, get_group_id(0))] = partial_sums[hook(1, 0)];
  }
}