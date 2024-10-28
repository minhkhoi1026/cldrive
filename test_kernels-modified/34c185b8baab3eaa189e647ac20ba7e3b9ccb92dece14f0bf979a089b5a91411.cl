//{"float_buffer":2,"index_buffer":3,"result":4,"size":1,"vec":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int float_vector1_index_norm_inf_impl(global const float* vec, unsigned int size, local float* float_buffer, local unsigned int* index_buffer) {
  float cur_max = 0.0f;
  float tmp;
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    tmp = fabs(vec[hook(0, i)]);
    if (cur_max < tmp) {
      float_buffer[hook(2, get_global_id(0))] = tmp;
      index_buffer[hook(3, get_global_id(0))] = i;
      cur_max = tmp;
    }
  }

  for (unsigned int stride = get_global_size(0) / 2; stride > 0; stride /= 2) {
    barrier(0x01);
    if (get_global_id(0) < stride) {
      if (float_buffer[hook(2, get_global_id(0))] < float_buffer[hook(2, get_global_id(0) + stride)]) {
        index_buffer[hook(3, get_global_id(0))] = index_buffer[hook(3, get_global_id(0) + stride)];
        float_buffer[hook(2, get_global_id(0))] = float_buffer[hook(2, get_global_id(0) + stride)];
      }
    }
  }

  return index_buffer[hook(3, 0)];
}

kernel void index_norm_inf(global float* vec, unsigned int size, local float* float_buffer, local unsigned int* index_buffer, global unsigned int* result) {
  unsigned int tmp = float_vector1_index_norm_inf_impl(vec, size, float_buffer, index_buffer);
  if (get_global_id(0) == 0)
    *result = tmp;
}