//{"input":0,"n":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void square(global float* input, global float* output, private int n) {
  size_t i = get_global_id(0);
  float temp = 0;

  if (i < n)
    temp = input[hook(0, i)];

  output[hook(1, i)] = temp * temp;
}