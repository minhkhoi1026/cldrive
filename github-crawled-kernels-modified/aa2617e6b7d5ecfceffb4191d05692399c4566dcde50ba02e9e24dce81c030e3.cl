//{"destination":0,"element_size":2,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_kernel(global uchar* destination, const global uchar* source, const uchar element_size) {
  const int tid = get_global_id(0);
  for (int i = 0; i < element_size; ++i) {
    destination[hook(0, tid * element_size + i)] = source[hook(1, tid * element_size + i)];
  }
}