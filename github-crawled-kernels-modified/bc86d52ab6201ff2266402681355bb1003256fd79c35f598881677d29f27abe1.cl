//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global ulong2* a, global ulong2* b, global ulong2* c) {
  *a = bitselect(*a, *b, *c);
}