//{"a":0,"b":1,"c":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot_product(global const float4* a, global const float4* b, global float* c) {
  int gid = get_global_id(0);

  float ax = a[hook(0, gid)].x;
  float ay = a[hook(0, gid)].y;
  float az = a[hook(0, gid)].z;
  float aw = a[hook(0, gid)].w;

  float bx = b[hook(1, gid)].x, by = b[hook(1, gid)].y, bz = b[hook(1, gid)].z, bw = b[hook(1, gid)].w;

  barrier(0x01);

  c[hook(2, gid)] = ax * bx;
  c[hook(2, gid)] += ay * by;
  c[hook(2, gid)] += az * bz;
  c[hook(2, gid)] += aw * bw;
}