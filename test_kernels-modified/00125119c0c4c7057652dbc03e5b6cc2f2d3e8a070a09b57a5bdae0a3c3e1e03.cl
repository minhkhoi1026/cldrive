//{"in":0,"len_in":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void skip2cols(global float2* in, global float2* out, unsigned int len_in) {
  const size_t n = get_global_size(0);
  const size_t m = get_global_id(0);
  const size_t sub_len = len_in / n;
  const size_t base_idx = m * sub_len;

  size_t i;
  for (i = 0; i < sub_len; i++) {
    out[hook(1, i * n + m)] = in[hook(0, base_idx + i)];
  }
}