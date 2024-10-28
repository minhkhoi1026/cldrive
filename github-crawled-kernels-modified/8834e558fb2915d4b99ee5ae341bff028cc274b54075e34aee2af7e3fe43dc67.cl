//{"image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Visualize(write_only image2d_t image) {
  unsigned int scale = 32;
  unsigned int float3 = get_group_id(0) * scale + get_group_id(1) % 8;

  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  write_imageui(image, coord, float3);
}