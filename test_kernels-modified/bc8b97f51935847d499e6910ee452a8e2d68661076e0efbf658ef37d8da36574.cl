//{"a":0,"answer":2,"b":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Vec_Add(global const double* a, global const double* b, global double* answer) {
  unsigned int xid = get_global_id(0);
  answer[hook(2, xid)] = a[hook(0, xid)] + b[hook(1, xid)];
}