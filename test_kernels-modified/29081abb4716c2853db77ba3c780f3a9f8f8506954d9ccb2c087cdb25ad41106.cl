//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sigmoid_vec(global double* input, global double* output) {
  unsigned int idx = get_global_id(0);
  double x = input[hook(0, idx)];
  output[hook(1, idx)] = 1.0 / (1.0 + exp(-x));
}