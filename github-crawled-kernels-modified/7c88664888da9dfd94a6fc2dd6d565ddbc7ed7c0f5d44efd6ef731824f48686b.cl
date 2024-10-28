//{"data":0,"m":2,"n":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dumb_kernel(global float* data, local int* n, int m) {
  int gid = get_global_id(0);
  data[hook(0, gid)] = data[hook(0, gid)] + (float)gid + 2.0f * m;
}