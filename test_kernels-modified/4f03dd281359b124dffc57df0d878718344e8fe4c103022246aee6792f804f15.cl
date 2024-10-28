//{"count":3,"input1":0,"input2":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SimpleFunction(global float* input1, global float* input2, global float* output, int count) {
  int i = get_global_id(0);

  if (i >= count)
    return;

  output[hook(2, i)] = input1[hook(0, i)] + input2[hook(1, i)];
}