//{"alpha":7,"error_estimate":9,"float2":13,"ip_rr0star":8,"p":4,"r0star":2,"residual":6,"result":5,"s":3,"size":11,"tmp0":0,"tmp1":1,"tmp_buffer":10,"vec1":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void helper_bicgstab_kernel2_parallel_reduction(local float* tmp_buffer) {
  for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
    barrier(0x01);
    if (get_local_id(0) < stride)
      tmp_buffer[hook(10, get_local_id(0))] += tmp_buffer[hook(10, get_local_id(0) + stride)];
  }
}

float bicgstab_kernel2_inner_prod(global const float* vec1, global const float* float2, unsigned int size, local float* tmp_buffer) {
  float tmp = 0;
  unsigned int i_end = ((size - 1) / get_local_size(0) + 1) * get_local_size(0);
  for (unsigned int i = get_local_id(0); i < i_end; i += get_local_size(0)) {
    if (i < size)
      tmp += vec1[hook(12, i)] * float2[hook(13, i)];
  }
  tmp_buffer[hook(10, get_local_id(0))] = tmp;

  helper_bicgstab_kernel2_parallel_reduction(tmp_buffer);

  barrier(0x01);

  return tmp_buffer[hook(10, 0)];
}

kernel void bicgstab_kernel2(global const float* tmp0, global const float* tmp1, global const float* r0star, global const float* s, global float* p, global float* result, global float* residual, global const float* alpha, global float* ip_rr0star, global float* error_estimate, local float* tmp_buffer, unsigned int size) {
  float omega_local = bicgstab_kernel2_inner_prod(tmp1, s, size, tmp_buffer) / bicgstab_kernel2_inner_prod(tmp1, tmp1, size, tmp_buffer);
  float alpha_local = alpha[hook(7, 0)];

  for (unsigned int i = get_local_id(0); i < size; i += get_local_size(0))
    result[hook(5, i)] += alpha_local * p[hook(4, i)] + omega_local * s[hook(3, i)];

  for (unsigned int i = get_local_id(0); i < size; i += get_local_size(0))
    residual[hook(6, i)] = s[hook(3, i)] - omega_local * tmp1[hook(1, i)];

  float new_ip_rr0star = bicgstab_kernel2_inner_prod(residual, r0star, size, tmp_buffer);
  float beta = (new_ip_rr0star / ip_rr0star[hook(8, 0)]) * (alpha_local / omega_local);

  for (unsigned int i = get_local_id(0); i < size; i += get_local_size(0))
    p[hook(4, i)] = residual[hook(6, i)] + beta * (p[hook(4, i)] - omega_local * tmp0[hook(0, i)]);

  float new_error_estimate = bicgstab_kernel2_inner_prod(residual, residual, size, tmp_buffer);

  barrier(0x02);

  if (get_global_id(0) == 0) {
    error_estimate[hook(9, 0)] = new_error_estimate;
    ip_rr0star[hook(8, 0)] = new_ip_rr0star;
  }
}