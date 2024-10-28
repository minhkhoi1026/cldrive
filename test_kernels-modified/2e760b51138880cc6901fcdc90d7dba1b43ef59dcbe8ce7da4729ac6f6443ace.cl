//{"add_value":1,"input":0,"mul_value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_mul_const_kernel(global float* input, const float add_value, const float mul_value) {
  const unsigned int idx = get_global_id(0);
  const float out_val = (input[hook(0, idx)] + add_value) * mul_value;
  input[hook(0, idx)] = out_val;
}