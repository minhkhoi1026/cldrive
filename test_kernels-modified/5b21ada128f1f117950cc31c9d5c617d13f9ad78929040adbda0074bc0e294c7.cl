//{"buf":0,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nullify(global unsigned int* const buf, const unsigned int n) {
  const size_t gid = get_global_id(0);
  if (gid < n)
    buf[hook(0, gid)] = 0;
}