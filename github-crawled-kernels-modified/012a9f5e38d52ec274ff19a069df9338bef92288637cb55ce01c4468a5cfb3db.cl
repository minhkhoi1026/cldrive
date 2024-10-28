//{"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void statelessKernel(global uchar* src) {
  unsigned int tid = get_global_id(0);
  src[hook(0, tid)] = 0xCD;
}