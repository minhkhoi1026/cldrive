//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Kernel_C(global int* input, global int* output) {
  printf("\nExecuting NODE C..");
}