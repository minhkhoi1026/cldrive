//{"output":0,"proto":1,"size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fill_double(global double* output, const double proto, const unsigned int size) {
  unsigned int tid = get_global_id(0);

  if (tid < size)
    output[hook(0, tid)] = proto;
}