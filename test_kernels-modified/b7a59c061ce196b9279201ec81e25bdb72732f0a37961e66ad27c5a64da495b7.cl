//{"data":0,"partial_sums":1,"sum":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduction_complete(global float4* data, local float4* partial_sums, global float* sum) {
  int lid = get_local_id(0);
  int group_size = get_local_size(0);

  partial_sums[hook(1, lid)] = data[hook(0, get_local_id(0))];
  barrier(0x01);

  for (int i = group_size / 2; i > 0; i >>= 1) {
    if (lid < i) {
      partial_sums[hook(1, lid)] += partial_sums[hook(1, lid + i)];
    }
    barrier(0x01);
  }

  if (lid == 0) {
    *sum = partial_sums[hook(1, 0)].s0 + partial_sums[hook(1, 0)].s1 + partial_sums[hook(1, 0)].s2 + partial_sums[hook(1, 0)].s3;
  }
}