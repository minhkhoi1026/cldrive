//{"freq":2,"in":0,"keep":4,"out":1,"phaseshift":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_alien_map(global const float4* in, global float4* out, float3 freq, float3 phaseshift, int3 keep) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float3 unit = (float3)(1.0f, 1.0f, 1.0f);
  float3 tmp = 0.5f * (unit + sin((2.0f * in_v.xyz - unit) * freq.xyz + phaseshift.xyz));
  float4 out_v;

  out_v.xyz = keep.xyz ? in_v.xyz : tmp;
  out_v.w = in_v.w;
  out[hook(1, gid)] = out_v;
}