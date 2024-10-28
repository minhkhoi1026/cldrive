//{"h":2,"im":0,"seq":3,"w":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_texture_kernel(write_only image2d_t im, int w, int h, int seq) {
  int2 coord = {get_global_id(0), get_global_id(1)};
  float4 float3 = {(float)coord.x / (float)w, (float)coord.y / (float)h, (float)abs(seq - w) / (float)w, 1.0f};
  write_imagef(im, coord, float3);
}