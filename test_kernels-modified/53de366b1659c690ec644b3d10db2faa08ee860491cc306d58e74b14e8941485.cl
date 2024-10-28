//{"in":0,"in_offset":2,"out":1,"out_offset":3,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_levels(global const float4* in, global float4* out, float in_offset, float out_offset, float scale) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 out_v;
  out_v.xyz = (in_v.xyz - in_offset) * scale + out_offset;
  out_v.w = in_v.w;
  out[hook(1, gid)] = out_v;
}