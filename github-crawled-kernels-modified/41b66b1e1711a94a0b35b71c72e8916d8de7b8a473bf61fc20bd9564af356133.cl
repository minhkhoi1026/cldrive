//{"arg":1,"arg2":2,"dst":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute((reqd_work_group_size((1024 * 32), 1, 1))) __attribute((num_simd_work_items(16))) mem_writestream(global unsigned int* dst, unsigned int arg, unsigned int arg2) {
  int gid = get_global_id(0);
  dst[hook(0, gid)] = gid;
}