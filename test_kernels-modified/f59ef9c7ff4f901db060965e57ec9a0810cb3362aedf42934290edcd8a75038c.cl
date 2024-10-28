//{"dst":0,"offset":2,"pattern0":1,"pattern1":4,"size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __cl_fill_region_align128(global float16* dst, float16 pattern0, unsigned int offset, unsigned int size, float16 pattern1) {
  int i = get_global_id(0);
  if (i < size) {
    dst[hook(0, i * 2 + offset)] = pattern0;
    dst[hook(0, i * 2 + offset + 1)] = pattern1;
  }
}