//{"dest":0,"dt":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_source(global float* dest, global float* src, float dt) {
  int gid = get_global_id(0);
  dest[hook(0, gid)] += dt * src[hook(1, gid)];
}