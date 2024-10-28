//{"aux":1,"in":0,"out":2,"value":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_threshold(global const float2* in, global const float* aux, global float2* out, float value) {
  int gid = get_global_id(0);
  float2 in_v = in[hook(0, gid)];
  float aux_v = (aux) ? aux[hook(1, gid)] : value;
  float2 out_v;
  out_v.x = (in_v.x >= aux_v) ? 1.0f : 0.0f;
  out_v.y = in_v.y;
  out[hook(2, gid)] = out_v;
}