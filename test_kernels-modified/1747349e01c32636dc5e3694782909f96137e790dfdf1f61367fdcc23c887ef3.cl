//{"inputA":0,"inputB":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vectorAdd(global const int* inputA, global const int* inputB, global int* output) {
  output[hook(2, get_global_id(0))] = inputA[hook(0, get_global_id(0))] + inputB[hook(1, get_global_id(0))];
}