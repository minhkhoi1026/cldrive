//{"a":0,"inc":1,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global unsigned int* const a, global const unsigned int* const inc, const unsigned int n) {
  const size_t gid = get_global_id(0);
  if (gid < n)
    a[hook(0, gid)] += inc[hook(1, gid / (2 * get_local_size(0)))];
}