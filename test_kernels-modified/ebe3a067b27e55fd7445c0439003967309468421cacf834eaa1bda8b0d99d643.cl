//{"dst":1,"n":3,"offset":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ScanNaive(global int* src, global int* dst, unsigned int offset, unsigned int n) {
  size_t id = get_global_id(0);

  if (id >= n)
    return;

  if (id >= offset)
    dst[hook(1, id)] = src[hook(0, id)] + src[hook(0, id - offset)];
  else if (id >= (offset >> 1))
    dst[hook(1, id)] = src[hook(0, id)];
}