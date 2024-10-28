//{"a":0,"b":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mutate(global const uchar* const a, global unsigned int* const b, const unsigned int n) {
  const size_t gid = get_global_id(0);
  if (gid < n)
    b[hook(1, gid)] = a[hook(0, gid)];
}