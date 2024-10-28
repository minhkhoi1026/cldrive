//{"retval":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void foo(global uchar* retval) {
  int gid = get_global_id(0);
  if (gid > 0)
    goto foobar;
  retval[hook(0, gid)] = 0;
  return;

foobar:
  retval[hook(0, gid)] = 1;
}