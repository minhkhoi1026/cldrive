//{"group_buffer":3,"size":1,"tmp_buffer":2,"vec":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float impl_norm_inf(global const float* vec, unsigned int start_index, unsigned int end_index, local float* tmp_buffer) {
  float tmp = 0;
  for (unsigned int i = start_index + get_local_id(0); i < end_index; i += get_local_size(0))
    tmp = fmax(fabs(vec[hook(0, i)]), tmp);
  tmp_buffer[hook(2, get_local_id(0))] = tmp;

  for (unsigned int stride = get_global_size(0) / 2; stride > 0; stride /= 2) {
    barrier(0x01);
    if (get_global_id(0) < stride)
      tmp_buffer[hook(2, get_global_id(0))] = fmax(tmp_buffer[hook(2, get_global_id(0))], tmp_buffer[hook(2, get_global_id(0) + stride)]);
  }

  return tmp_buffer[hook(2, 0)];
}

kernel void norm_inf(global const float* vec, unsigned int size, local float* tmp_buffer, global float* group_buffer) {
  float tmp = impl_norm_inf(vec, (get_group_id(0) * size) / get_num_groups(0), ((get_group_id(0) + 1) * size) / get_num_groups(0), tmp_buffer);

  if (get_local_id(0) == 0)
    group_buffer[hook(3, get_group_id(0))] = tmp;
}