//{"py":2,"size":0,"skip":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_identity_kernel(const unsigned size, const unsigned skip, global float* py) {
  const unsigned i = get_global_id(0);
  if (i < size)
    py[hook(2, i)] = !(i % skip);
}