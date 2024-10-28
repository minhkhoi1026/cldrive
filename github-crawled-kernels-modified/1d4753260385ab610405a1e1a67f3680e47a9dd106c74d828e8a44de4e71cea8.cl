//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global char3* a, global char3* b, global uchar3* c) {
  *a = select(*a, *b, *c);
}