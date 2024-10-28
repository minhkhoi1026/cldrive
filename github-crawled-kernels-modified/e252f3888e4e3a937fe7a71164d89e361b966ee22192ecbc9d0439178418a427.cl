//{"inputA":0,"inputB":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hello_world_opencl(global int* restrict inputA, global int* restrict inputB, global int* restrict output) {
  int i = get_global_id(0);

  output[hook(2, i)] = inputA[hook(0, i)] + inputB[hook(1, i)];
}