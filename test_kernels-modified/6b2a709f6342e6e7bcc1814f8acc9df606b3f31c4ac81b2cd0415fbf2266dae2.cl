//{"dummy_inthe_middle":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global float* input, int dummy_inthe_middle, global float* output) {
  int i = get_global_id(0);
  output[hook(2, i)] = input[hook(0, i)] * input[hook(0, i)];
  printf("%f,", output[hook(2, i)]);
}