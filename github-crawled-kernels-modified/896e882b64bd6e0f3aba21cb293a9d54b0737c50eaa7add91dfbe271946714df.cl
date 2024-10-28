//{"float2":1,"group_buffer":4,"size":2,"tmp_buffer":3,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void helper_inner_prod_parallel_reduction(local float* tmp_buffer) {
  for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
    barrier(0x01);
    if (get_local_id(0) < stride)
      tmp_buffer[hook(3, get_local_id(0))] += tmp_buffer[hook(3, get_local_id(0) + stride)];
  }
}

float impl_inner_prod(global const float* vec1, global const float* float2, unsigned int start_index, unsigned int end_index, local float* tmp_buffer) {
  float tmp = 0;
  for (unsigned int i = start_index + get_local_id(0); i < end_index; i += get_local_size(0))
    tmp += vec1[hook(0, i)] * float2[hook(1, i)];
  tmp_buffer[hook(3, get_local_id(0))] = tmp;

  helper_inner_prod_parallel_reduction(tmp_buffer);

  return tmp_buffer[hook(3, 0)];
}

kernel void inner_prod(global const float* vec1, global const float* float2, unsigned int size, local float* tmp_buffer, global float* group_buffer) {
  float tmp = impl_inner_prod(vec1, float2, (get_group_id(0) * size) / get_num_groups(0), ((get_group_id(0) + 1) * size) / get_num_groups(0), tmp_buffer);

  if (get_local_id(0) == 0)
    group_buffer[hook(4, get_group_id(0))] = tmp;
}