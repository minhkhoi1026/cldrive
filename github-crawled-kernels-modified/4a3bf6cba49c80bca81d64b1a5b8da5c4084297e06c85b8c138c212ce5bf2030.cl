//{"input":0,"n":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global float* input, global float* output, int n) {
  int i = get_global_id(0);
  if ((i >= 0) && (i < n)) {
    output[hook(1, i)] = input[hook(0, i)] * input[hook(0, i)];
  }
}