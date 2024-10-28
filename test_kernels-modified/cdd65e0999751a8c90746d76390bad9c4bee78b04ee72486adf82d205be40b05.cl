//{"input":0,"value":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_const_kernel(global float* input, float value) {
  const unsigned int idx = get_global_id(0);
  const float out_val = input[hook(0, idx)] + value;

  input[hook(0, idx)] = out_val;
}