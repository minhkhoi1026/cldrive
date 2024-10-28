//{"dest":2,"src1":0,"src2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_vectors(global const float2* src1, global const float2* src2, global float2* dest) {
  int gid = get_global_id(0);
  dest[hook(2, gid)] = (float2)((src1[hook(0, gid)].x + src2[hook(1, gid)].x), (src1[hook(0, gid)].y + src2[hook(1, gid)].y));
}