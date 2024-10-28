//{"add_value":1,"input":0,"mul_value":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_mul_const_with_thresh_kernel(global float* input, const float add_value, const float mul_value) {
  const float short_lim = log((float)65535);
  const unsigned int idx = get_global_id(0);
  const float out_val = (input[hook(0, idx)] + add_value) * mul_value;
  if (out_val < 0.0f) {
    input[hook(0, idx)] = 0.0f;
  } else if (out_val > short_lim) {
    input[hook(0, idx)] = short_lim;
  } else {
    input[hook(0, idx)] = out_val;
  }
}