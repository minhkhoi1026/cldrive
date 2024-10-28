//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global uchar* a, global uchar* b, global uchar* c) {
  *a = bitselect(*a, *b, *c);
}