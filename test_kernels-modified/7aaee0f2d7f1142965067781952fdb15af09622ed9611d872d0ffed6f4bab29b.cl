//{"a":0,"b":1,"c":3,"n":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global const float* a, global const float* b, const unsigned int n, global float* c) {
  int gid = get_global_id(0);

  if (gid < n) {
    c[hook(3, gid)] = a[hook(0, gid)] + b[hook(1, gid)];
  }
}