//{"dst":0,"dstofs":1,"src":2,"srcofs":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void memcpy(global unsigned int* dst, unsigned int dstofs, global unsigned int* src, unsigned int srcofs) {
  dst[hook(0, dstofs + get_global_id(0))] = src[hook(2, srcofs + get_global_id(0))];
}