//{"coeff1":2,"coeff2":3,"coeff3":4,"in":0,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_color_temperature(global const float4* in, global float4* out, float coeff1, float coeff2, float coeff3) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float4 out_v;
  out_v = in_v * (float4)(coeff1, coeff2, coeff3, 1.0f);
  out[hook(1, gid)] = out_v;
}