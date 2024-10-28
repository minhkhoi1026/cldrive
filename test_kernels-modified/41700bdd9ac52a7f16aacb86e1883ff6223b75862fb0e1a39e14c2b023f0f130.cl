//{"a":0,"b":1,"buf_size":4,"c":2,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global const unsigned int* a, global const unsigned int* b, global unsigned int* c, unsigned int d, unsigned int buf_size) {
  unsigned int gid = get_global_id(0);

  if (gid < buf_size)
    c[hook(2, gid)] = a[hook(0, gid)] + b[hook(1, gid)] + d;
}