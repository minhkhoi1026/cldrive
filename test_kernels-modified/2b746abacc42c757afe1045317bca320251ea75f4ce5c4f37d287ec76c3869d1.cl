//{"diff":3,"in":0,"min":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_stretch_contrast(global const float4* in, global float4* out, float4 min, float4 diff) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];

  in_v = (in_v - min) / diff;

  out[hook(1, gid)] = in_v;
}