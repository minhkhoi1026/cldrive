//{"coef":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void multi_filter(global float2* in, global float* out, global float2* coef) {
  const size_t m = get_global_id(0);
  const size_t base_out = m * (153600 - 137 + 1);
  const size_t base_coef = m * 137;

  float2 acc, in_tmp, coef_tmp;
  size_t i, j;
  for (i = 0; i < (153600 - 137 + 1); i++) {
    acc = (float2)(0.0f, 0.0f);

    for (j = 0; j < 137; j++) {
      coef_tmp = coef[hook(2, base_coef + j)];
      in_tmp = in[hook(0, i + j)];
      acc = acc + (float2)(in_tmp.x * coef_tmp.x - in_tmp.y * coef_tmp.y, in_tmp.x * coef_tmp.y + in_tmp.y * coef_tmp.x);
    }

    out[hook(1, base_out + i)] = acc.x * acc.x + acc.y * acc.y;
  }
}