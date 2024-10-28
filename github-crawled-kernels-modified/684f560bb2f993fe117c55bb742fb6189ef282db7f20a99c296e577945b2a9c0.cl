//{"n":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void norm(global float2* x, int n) {
  unsigned int gid = get_global_id(0);
  unsigned int nid = get_global_id(1);

  x[hook(0, nid * n + gid)] = x[hook(0, nid * n + gid)] / (float2)((float)n, (float)n);
}