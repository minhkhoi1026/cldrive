//{"dest":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conj_vector(global const float2* src, global float2* dest) {
  int gid = get_global_id(0);
  dest[hook(1, gid)] = ((float2)(1, -1)) * src[hook(0, gid)];
}