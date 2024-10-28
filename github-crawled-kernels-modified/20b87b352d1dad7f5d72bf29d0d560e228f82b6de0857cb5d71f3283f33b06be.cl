//{"a":3,"input":0,"output":1,"scale":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_sum(global float* input, global float* output, float scale, int a) {
  const int c = get_global_id(0);
  if (a == 0)
    output[hook(1, c)] = (scale * input[hook(0, c)]);
  else
    output[hook(1, c)] += (scale * input[hook(0, c)]);
}