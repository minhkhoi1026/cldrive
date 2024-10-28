//{"input_a":0,"input_b":1,"n":3,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t smp_none = 0 | 0 | 0x10;
kernel void ElementSub_BUF(global float* input_a, global float* input_b, global float* output, const unsigned int n) {
  int idx = get_global_id(0);
  if (idx >= n)
    return;
  output[hook(2, idx)] = input_a[hook(0, idx)] - input_b[hook(1, idx)];
}