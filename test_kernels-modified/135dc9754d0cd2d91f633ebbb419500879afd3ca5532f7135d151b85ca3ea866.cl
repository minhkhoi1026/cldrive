//{"in":0,"levels":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_posterize(global const float4* in, global float4* out, float levels) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];

  in_v.xyz = trunc(in_v.xyz * levels + (float3)(0.5f)) / levels;
  out[hook(1, gid)] = in_v;
}