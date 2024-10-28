//{"aux":1,"in":0,"out":2,"value":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_opacity_RaGaBaA_float(global const float4* in, global const float* aux, global float4* out, float value) {
  int gid = get_global_id(0);
  float4 in_v = in[hook(0, gid)];
  float aux_v = (aux) ? aux[hook(1, gid)] : 1.0f;
  float4 out_v;
  out_v = in_v * aux_v * value;
  out[hook(2, gid)] = out_v;
}