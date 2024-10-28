//{"cmem0":0,"data0":2,"offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mykernel(global char* cmem0, unsigned int offset) {
  global int* data0 = (global int*)(cmem0 + offset);
  int tid = get_global_id(0);
  data0[hook(2, tid)] = tid + 123;
}