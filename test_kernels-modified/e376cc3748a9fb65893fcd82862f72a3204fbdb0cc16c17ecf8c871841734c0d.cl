//{"aux":1,"in":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_weighted_blend(global const float4* in, global const float4* aux, global float4* out) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 aux_v = aux[hook(1, gid)];
  float4 out_v;
  float in_weight;
  float aux_weight;
  float total_alpha = in_v.w + aux_v.w;

  total_alpha = total_alpha == 0 ? 1 : total_alpha;

  in_weight = in_v.w / total_alpha;
  aux_weight = 1.0f - in_weight;

  out_v.xyz = in_weight * in_v.xyz + aux_weight * aux_v.xyz;
  out_v.w = total_alpha;
  out[hook(2, gid)] = out_v * ((in_v.w + aux_v.w) > 0.f);
}