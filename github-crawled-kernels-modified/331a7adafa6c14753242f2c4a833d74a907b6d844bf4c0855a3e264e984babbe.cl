//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_invert(global const float4* in, global float4* out) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 out_v;
  out_v.xyz = (1.0f - in_v.xyz);
  out_v.w = in_v.w;
  out[hook(1, gid)] = out_v;
}