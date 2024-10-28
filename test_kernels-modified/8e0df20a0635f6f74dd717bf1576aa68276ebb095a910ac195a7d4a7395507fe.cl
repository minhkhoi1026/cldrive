//{"dst":0,"dstofs":1,"val":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void memset(global unsigned int* dst, unsigned int dstofs, unsigned int val) {
  dst[hook(0, get_global_id(0) + dstofs)] = val;
}