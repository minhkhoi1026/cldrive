//{"inputA":1,"inputB":2,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kern(global float* output, global float* inputA, global float* inputB) {
  size_t i = get_global_id(0);
  output[hook(0, i)] = inputA[hook(1, i)] + inputB[hook(2, i)];
}