//{"in":0,"len":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convert_heads(global const unsigned int* restrict in, global unsigned int* restrict out, const unsigned int len) {
  const unsigned int thread = get_global_id(0);
  const unsigned int even = 2 * thread;
  const unsigned int odd = 2 * thread + 1;
  if (even < len)
    out[hook(1, even)] = (even == len - 1) ? 1 : in[hook(0, even + 1)];
  if (odd < len)
    out[hook(1, odd)] = (odd == len - 1) ? 1 : in[hook(0, odd + 1)];
}