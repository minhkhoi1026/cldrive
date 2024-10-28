//{"a_vec":0,"b_vec":1,"output":2,"partial_dot":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot_product(global float4* a_vec, global float4* b_vec, global float* output, local float4* partial_dot) {
  int gid = get_global_id(0);
  int lid = get_local_id(0);
  int group_size = get_local_size(0);

  partial_dot[hook(3, lid)] = a_vec[hook(0, gid)] * b_vec[hook(1, gid)];
  barrier(0x01);

  for (int i = group_size / 2; i > 0; i >>= 1) {
    if (lid < i) {
      partial_dot[hook(3, lid)] += partial_dot[hook(3, lid + i)];
    }
    barrier(0x01);
  }

  if (lid == 0) {
    output[hook(2, get_group_id(0))] = dot(partial_dot[hook(3, 0)], (float4)(1.0f));
  }
}