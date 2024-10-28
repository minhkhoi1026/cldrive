//{"alpha":4,"float2":9,"ip_rr0star":5,"r0star":1,"residual":2,"s":3,"size":7,"tmp0":0,"tmp_buffer":6,"vec1":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void helper_bicgstab_kernel1_parallel_reduction(local float* tmp_buffer) {
  for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
    barrier(0x01);
    if (get_local_id(0) < stride)
      tmp_buffer[hook(6, get_local_id(0))] += tmp_buffer[hook(6, get_local_id(0) + stride)];
  }
}

float bicgstab_kernel1_inner_prod(global const float* vec1, global const float* float2, unsigned int size, local float* tmp_buffer) {
  float tmp = 0;
  unsigned int i_end = ((size - 1) / get_local_size(0) + 1) * get_local_size(0);
  for (unsigned int i = get_local_id(0); i < i_end; i += get_local_size(0)) {
    if (i < size)
      tmp += vec1[hook(8, i)] * float2[hook(9, i)];
  }
  tmp_buffer[hook(6, get_local_id(0))] = tmp;

  helper_bicgstab_kernel1_parallel_reduction(tmp_buffer);

  barrier(0x01);

  return tmp_buffer[hook(6, 0)];
}

kernel void bicgstab_kernel1(global const float* tmp0, global const float* r0star, global const float* residual, global float* s, global float* alpha, global const float* ip_rr0star, local float* tmp_buffer, unsigned int size) {
  float alpha_local = ip_rr0star[hook(5, 0)] / bicgstab_kernel1_inner_prod(tmp0, r0star, size, tmp_buffer);

  for (unsigned int i = get_local_id(0); i < size; i += get_local_size(0))
    s[hook(3, i)] = residual[hook(2, i)] - alpha_local * tmp0[hook(0, i)];

  if (get_global_id(0) == 0)
    alpha[hook(4, 0)] = alpha_local;
}