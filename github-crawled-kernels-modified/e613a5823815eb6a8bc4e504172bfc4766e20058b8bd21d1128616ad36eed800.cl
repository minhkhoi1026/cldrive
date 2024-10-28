//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_copy_weigthed_blend(global const float4* in, global float4* out) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  out[hook(1, gid)] = in_v;
}