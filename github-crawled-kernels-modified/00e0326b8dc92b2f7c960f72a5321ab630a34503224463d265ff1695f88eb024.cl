//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void doubleInput(global float* input, global float* output) {
  int tid = get_global_id(0);
  output[hook(1, tid)] = 2 * 3.14575454 * 0.2312232 * 1.3232 * 0.99943 * input[hook(0, tid)];
}