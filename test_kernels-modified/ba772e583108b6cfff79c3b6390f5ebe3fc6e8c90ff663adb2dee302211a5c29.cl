//{"chroma":3,"hue":2,"in":0,"lightness":4,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_hue_chroma(global const float4* in, global float4* out, float hue, float chroma, float lightness) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 out_v;
  out_v.x = in_v.x + lightness;
  out_v.y = clamp(in_v.y + chroma, 0.f, 200.f);
  out_v.z = in_v.z + hue;
  out_v.w = in_v.w;
  out[hook(1, gid)] = out_v;
}