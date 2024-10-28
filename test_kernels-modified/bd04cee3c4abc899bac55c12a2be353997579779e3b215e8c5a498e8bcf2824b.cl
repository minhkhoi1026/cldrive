//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot_product(global const float4* a, global const float4* b, global float* c) {
  int gid = get_global_id(0);

  barrier(0x01);

  c[hook(2, gid)] = a[hook(0, gid)].x * b[hook(1, gid)].x;
  c[hook(2, gid)] += a[hook(0, gid)].y * b[hook(1, gid)].y;
  c[hook(2, gid)] += a[hook(0, gid)].z * b[hook(1, gid)].z;
  c[hook(2, gid)] += a[hook(0, gid)].w * b[hook(1, gid)].w;
}