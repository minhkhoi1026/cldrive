//{"in":0,"len_coef":4,"len_out":3,"out":1,"out_abs2":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void result_combine(global float2* in, global float2* out, global float* out_abs2, unsigned int len_out, unsigned int len_coef) {
  const size_t n = get_global_size(0);
  const size_t m = get_global_id(0);
  const size_t m1 = get_global_id(1);
  const size_t filter_len = len_coef;
  const size_t sub_len_out = len_out / n;
  const size_t sub_len_in = sub_len_out + filter_len - 1;
  const size_t base_in = m1 * sub_len_in * n;
  const size_t base_out = m1 * len_out;

  size_t base_linear_idx = m * sub_len_out;

  size_t i, base_idx, base_tail_idx;
  float2 tmp_val;
  for (i = 0; i < filter_len - 1; i++) {
    base_idx = i * n;
    base_tail_idx = (sub_len_out + i) * n;
    tmp_val = in[hook(0, base_in + base_idx + m + 1)] + in[hook(0, base_in + base_tail_idx + m)];
    out[hook(1, base_out + base_linear_idx + i)] = tmp_val;
    out_abs2[hook(2, base_out + base_linear_idx + i)] = tmp_val.x * tmp_val.x + tmp_val.y * tmp_val.y;
  }

  for (i = filter_len - 1; i < sub_len_out; i++) {
    base_idx = i * n;
    tmp_val = in[hook(0, base_in + base_idx + m + 1)];
    out[hook(1, base_out + base_linear_idx + i)] = tmp_val;
    out_abs2[hook(2, base_out + base_linear_idx + i)] = tmp_val.x * tmp_val.x + tmp_val.y * tmp_val.y;
  }
}