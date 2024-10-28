//{"dest":3,"partSize":2,"size":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void partialTrueCount(global uchar* x, const unsigned int size, const unsigned int partSize, global unsigned int* dest) {
  unsigned int part = get_global_id(0);

  unsigned int correct = 0;
  for (size_t i = part * partSize, end = min(part * partSize + partSize, size); i < end; ++i) {
    if (x[hook(0, i)]) {
      ++correct;
    }
  }
  dest[hook(3, part)] = correct;
}