//{"blue":4,"dst_buf":1,"green":3,"red":2,"src_buf":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gegl_mono_mixer(global const float4* src_buf, global float2* dst_buf, float red, float green, float blue) {
  int gid = get_global_id(0);
  float4 in_v = src_buf[hook(0, gid)];
  dst_buf[hook(1, gid)].x = in_v.x * red + in_v.y * green + in_v.z * blue;
  dst_buf[hook(1, gid)].y = in_v.w;
}