//{"coef":2,"in":0,"len_coef":4,"len_in":3,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multi_filter(global float2* in, global float2* out, global float2* coef, unsigned int len_in, unsigned int len_coef) {
  const size_t n = get_global_size(0);
  const size_t m = get_global_id(0);
  const size_t m1 = get_global_id(1);
  const size_t filter_len = len_coef;
  const size_t sub_len_in = len_in / n;
  const size_t sub_len_out = sub_len_in + filter_len - 1;
  const size_t base_coef = m1 * len_coef;
  const size_t base_out = m1 * sub_len_out * n;

  float2 coef_tmp, acc, in_tmp;
  size_t i, j, base_idx, coef_idx;
  if (m == 0) {
    for (i = (sub_len_out - filter_len + 1); i < sub_len_out; i++) {
      base_idx = i * n;
      out[hook(1, base_out + base_idx)] = (float2)(0.0f, 0.0f);
    }
  }

  for (i = 0; i < filter_len - 1; i++) {
    acc = (float2)(0.0f, 0.0f);

    for (j = 0; j < i + 1; j++) {
      base_idx = j * n;
      coef_idx = (filter_len - 1) - i + j;
      coef_tmp = coef[hook(2, base_coef + coef_idx)];
      in_tmp = in[hook(0, base_idx + m)];
      acc = acc + (float2)(in_tmp.x * coef_tmp.x - in_tmp.y * coef_tmp.y, in_tmp.x * coef_tmp.y + in_tmp.y * coef_tmp.x);
    }

    base_idx = i * n;
    out[hook(1, base_out + base_idx + m + 1)] = acc;
  }

  for (i = filter_len - 1; i <= sub_len_in - 1; i++) {
    acc = (float2)(0.0f, 0.0f);

    for (j = 0; j < filter_len; j++) {
      base_idx = (i - (filter_len - 1) + j) * n;
      coef_idx = j;
      coef_tmp = coef[hook(2, base_coef + coef_idx)];
      in_tmp = in[hook(0, base_idx + m)];
      acc = acc + (float2)(in_tmp.x * coef_tmp.x - in_tmp.y * coef_tmp.y, in_tmp.x * coef_tmp.y + in_tmp.y * coef_tmp.x);
    }

    base_idx = i * n;
    out[hook(1, base_out + base_idx + m + 1)] = acc;
  }

  for (i = sub_len_in; i < sub_len_out; i++) {
    acc = (float2)(0.0f, 0.0f);

    for (j = 0; j < sub_len_out - i; j++) {
      base_idx = (i - (filter_len - 1) + j) * n;
      coef_idx = j;
      coef_tmp = coef[hook(2, base_coef + coef_idx)];
      in_tmp = in[hook(0, base_idx + m)];
      acc = acc + (float2)(in_tmp.x * coef_tmp.x - in_tmp.y * coef_tmp.y, in_tmp.x * coef_tmp.y + in_tmp.y * coef_tmp.x);
    }

    base_idx = i * n;
    out[hook(1, base_out + base_idx + m + 1)] = acc;
  }
}