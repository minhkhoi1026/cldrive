//{"a":2,"c":1,"i":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(write_only image2d_t i, int2 c, uint4 a) {
  write_imageui(i, c, a);
}