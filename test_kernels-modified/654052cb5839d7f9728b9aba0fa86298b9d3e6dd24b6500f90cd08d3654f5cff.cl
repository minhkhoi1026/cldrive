//{"aux":1,"in":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void svg_src_over(global const float4* in, global const float4* aux, global float4* out) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 aux_v = aux[hook(1, gid)];
  float4 out_v;
  out_v.xyz = aux_v.xyz + in_v.xyz * (1.0f - aux_v.w);
  out_v.w = aux_v.w + in_v.w - aux_v.w * in_v.w;
  out[hook(2, gid)] = out_v;
}