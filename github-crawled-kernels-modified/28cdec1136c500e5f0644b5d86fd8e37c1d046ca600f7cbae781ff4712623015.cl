//{"arg":1,"arg2":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute((reqd_work_group_size((1024 * 32), 1, 1))) __attribute((num_simd_work_items(16))) mem_read_writestream(global unsigned int* src, unsigned int arg, unsigned int arg2) {
  int gid = get_global_id(0) + arg2;
  int gvalue = src[hook(0, gid)];
  src[hook(0, gid)] = 2 + gvalue;
}