//{"a":0,"aoffset":2,"b":1,"boffset":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sub(global double* a, global const double* b, const int aoffset, const int boffset) {
  int gid = get_global_id(0);
  a[hook(0, gid + aoffset)] -= b[hook(1, gid + boffset)];
}