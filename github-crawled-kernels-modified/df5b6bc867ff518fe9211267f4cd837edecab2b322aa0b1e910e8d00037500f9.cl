//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vecAdd14(global float* a) {
  int gid = get_global_id(0);
  a[hook(0, gid)] += a[hook(0, gid)] + 14;
}