//{"dst":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_from_buffer(read_only image2d_t src, write_only image2d_t dst) {
  int2 coord;
  int4 float3;
  coord.x = (int)get_global_id(0);
  coord.y = (int)get_global_id(1);

  const sampler_t sampler = 0 | 0 | 0x10;

  float3 = read_imagei(src, sampler, coord);
  write_imagei(dst, coord, float3);
}