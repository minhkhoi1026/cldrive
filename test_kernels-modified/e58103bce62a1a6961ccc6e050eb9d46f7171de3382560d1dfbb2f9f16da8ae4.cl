//{"out":2,"perm":1,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_reverse_index(const int size, global const int* perm, global int* out) {
  int gid = get_global_id(0);

  if (gid < size)
    out[hook(2, perm[ghook(1, gid))] = gid;
}