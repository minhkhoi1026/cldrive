//{"im":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(read_write image2d_t im) {
  int4 x = read_imagei(im, (int2)(0, 0));
  write_imagei(im, (int2)(0, 0), x);
}