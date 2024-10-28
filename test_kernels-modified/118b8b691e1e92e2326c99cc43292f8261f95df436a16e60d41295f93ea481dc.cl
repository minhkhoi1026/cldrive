//{"color_diff":2,"in":0,"max":4,"min":3,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_color_exchange(global const float4* in, global float4* out, float3 color_diff, float3 min, float3 max) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 out_v;

  if (in_v.x > min.x && in_v.x < max.x && in_v.y > min.y && in_v.y < max.y && in_v.z > min.z && in_v.z < max.z) {
    out_v.x = clamp(in_v.x + color_diff.x, 0.0f, 1.0f);
    out_v.y = clamp(in_v.y + color_diff.y, 0.0f, 1.0f);
    out_v.z = clamp(in_v.z + color_diff.z, 0.0f, 1.0f);
  } else {
    out_v.xyz = in_v.xyz;
  }

  out_v.w = in_v.w;
  out[hook(1, gid)] = out_v;
}