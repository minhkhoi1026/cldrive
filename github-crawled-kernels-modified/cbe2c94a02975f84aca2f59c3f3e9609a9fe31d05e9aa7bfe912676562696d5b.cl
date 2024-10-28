//{"dst":0,"offset":2,"pattern":1,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_fill_region_unalign(global char* dst, char pattern, unsigned int offset, unsigned int size) {
  int i = get_global_id(0);
  if (i < size) {
    dst[hook(0, i + offset)] = pattern;
  }
}