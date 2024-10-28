//{"a":0,"b":1,"c":2,"n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global const float* a, global const float* b, global float* c, long n) {
  int gid = get_global_id(0);
  if (gid < n)
    c[hook(2, gid)] = a[hook(0, gid)] + b[hook(1, gid)];
}