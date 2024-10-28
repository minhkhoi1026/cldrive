//{"a":0,"b":1,"c":2,"d":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sampleKernel(global const float* a, global const float* b, global const float* c, global float* d) {
  int gid = get_global_id(0);
  d[hook(3, gid)] = sqrt((a[hook(0, gid)] * a[hook(0, gid)]) + (b[hook(1, gid)] * b[hook(1, gid)]) + (c[hook(2, gid)] * c[hook(2, gid)]));
}