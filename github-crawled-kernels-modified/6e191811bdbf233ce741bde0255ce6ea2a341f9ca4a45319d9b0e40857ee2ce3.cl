//{"addend":1,"res":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_scalar(global unsigned int const* const src, private unsigned int const addend, global unsigned int* const res) {
  unsigned int const idx = get_global_id(0);

  res[hook(2, idx)] = src[hook(0, idx)] + addend;
}