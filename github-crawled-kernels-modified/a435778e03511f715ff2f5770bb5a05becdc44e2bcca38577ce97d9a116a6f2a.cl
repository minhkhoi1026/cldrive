//{"float3":2,"tex_size":1,"texture":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clear_texture(write_only image2d_t texture, int2 tex_size, float4 float3) {
  int id = get_global_id(0);
  int2 pixel = (int2)(id % tex_size.x, id / tex_size.x);
  write_imagef(texture, pixel, float3);
}