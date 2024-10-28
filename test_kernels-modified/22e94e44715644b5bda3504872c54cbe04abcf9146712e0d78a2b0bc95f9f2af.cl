//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void somekernel(global int* src, global int* dst) {
  int id = get_global_id(0);
  dst[hook(1, id)] = (int)pown((float)src[hook(0, id)], 4);
}