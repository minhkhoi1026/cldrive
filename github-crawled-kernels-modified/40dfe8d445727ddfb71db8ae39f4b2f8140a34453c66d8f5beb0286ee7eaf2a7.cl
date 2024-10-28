//{"destination":2,"factor":0,"source":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void shrink_image(const float factor, read_only image2d_t source, write_only image2d_t destination) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  unsigned int pixel = read_imageui(source, sampler, (int2)(x, y)).x;

  int center_x = get_image_dim(source).x / 2;
  int center_y = get_image_dim(source).y / 2;
  int dest_x = x + ((center_x - x) * factor);
  int dest_y = y + ((center_y - y) * factor);
  write_imageui(destination, (int2)(dest_x, dest_y), pixel);
}