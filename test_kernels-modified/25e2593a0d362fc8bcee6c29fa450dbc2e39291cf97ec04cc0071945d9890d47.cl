//{"source":1,"target":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_copy(global float4* target, global float4* source) {
  size_t gid = get_global_id(0);

  target[hook(0, gid)].x = source[hook(1, gid)].x;
  target[hook(0, gid)].y = source[hook(1, gid)].y;
  target[hook(0, gid)].z = source[hook(1, gid)].z;
  target[hook(0, gid)].w = source[hook(1, gid)].w;
}