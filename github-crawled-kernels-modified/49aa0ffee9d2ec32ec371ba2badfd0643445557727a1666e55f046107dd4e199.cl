//{"dest":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void magnitude_squared(global const float2* src, global float* dest) {
  int gid = get_global_id(0);
  dest[hook(1, gid)] = src[hook(0, gid)].x * src[hook(0, gid)].x + src[hook(0, gid)].y * src[hook(0, gid)].y;
}