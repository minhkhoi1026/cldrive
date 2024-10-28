//{"input1":0,"input2":1,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Kernel_D(global int* input1, global int* input2, global int* output) {
  printf("\nExecuting NODE D..");
}