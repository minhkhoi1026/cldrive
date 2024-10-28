//{"destination":0,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void indirect_copy_kernel(global unsigned int* destination, const global unsigned int* source) {
  const int tid = get_global_id(0);
  const uchar* s = (uchar*)(source[hook(1, tid)]);
  uchar* d = (uchar*)(destination[hook(0, tid)]);
  *d = *s;
}