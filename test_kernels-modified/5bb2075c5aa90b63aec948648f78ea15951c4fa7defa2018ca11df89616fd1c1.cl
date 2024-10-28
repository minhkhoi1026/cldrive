//{"float3":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_color_to_alpha(global const float4* in, global float4* out, float4 float3) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 out_v = in_v;
  float4 alpha;

  alpha.w = in_v.w;

  if (float3.x < 0.00001f)
    alpha.x = in_v.x;
  else if (in_v.x > float3.x + 0.00001f)
    alpha.x = (in_v.x - float3.x) / (1.0f - float3.x);
  else if (in_v.x < float3.x - 0.00001f)
    alpha.x = (float3.x - in_v.x) / float3.x;
  else
    alpha.x = 0.0f;

  if (float3.y < 0.00001f)
    alpha.y = in_v.y;
  else if (in_v.y > float3.y + 0.00001f)
    alpha.y = (in_v.y - float3.y) / (1.0f - float3.y);
  else if (in_v.y < float3.y - 0.00001f)
    alpha.y = (float3.y - in_v.y) / float3.y;
  else
    alpha.y = 0.0f;

  if (float3.z < 0.00001f)
    alpha.z = in_v.z;
  else if (in_v.z > float3.z + 0.00001f)
    alpha.z = (in_v.z - float3.z) / (1.0f - float3.z);
  else if (in_v.z < float3.z - 0.00001f)
    alpha.z = (float3.z - in_v.z) / float3.z;
  else
    alpha.z = 0.0f;

  if (alpha.x > alpha.y) {
    if (alpha.x > alpha.z)
      out_v.w = alpha.x;
    else
      out_v.w = alpha.z;
  } else if (alpha.y > alpha.z) {
    out_v.w = alpha.y;
  } else {
    out_v.w = alpha.z;
  }

  if (out_v.w >= 0.00001f) {
    out_v.xyz = (out_v.xyz - float3.xyz) / out_v.www + float3.xyz;
    out_v.w *= alpha.w;
  }

  out[hook(1, gid)] = out_v;
}