//{"brightness":3,"contrast":2,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_brightness_contrast(global const float4* in, global float4* out, float contrast, float brightness) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 out_v;
  out_v.xyz = (in_v.xyz - 0.5f) * contrast + brightness + 0.5f;
  out_v.w = in_v.w;
  out[hook(1, gid)] = out_v;
}