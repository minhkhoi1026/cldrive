//{"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_value_invert(global const float4* in, global float4* out) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 out_v;

  float value = fmax(in_v.x, fmax(in_v.y, in_v.z));
  float minv = fmin(in_v.x, fmin(in_v.y, in_v.z));
  float delta = value - minv;

  if (value == 0.0f || delta == 0.0f) {
    out_v = (float4)((1.0f - value), (1.0f - value), (1.0f - value), in_v.w);
  } else {
    out_v = (float4)((1.0f - value) * in_v.x / value, (1.0f - value) * in_v.y / value, (1.0f - value) * in_v.z / value, in_v.w);
  }

  out_v.w = in_v.w;
  out[hook(1, gid)] = out_v;
}