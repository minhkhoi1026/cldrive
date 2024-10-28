//{"dst":0,"index":1,"src":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int kch;
kernel void reorder_const(global unsigned int* dst, global const unsigned int* index, constant unsigned int* src) {
  unsigned int gID = get_global_id(0);
  unsigned int ndx = index[hook(1, gID)];
  dst[hook(0, gID)] = src[hook(2, ndx)];
}