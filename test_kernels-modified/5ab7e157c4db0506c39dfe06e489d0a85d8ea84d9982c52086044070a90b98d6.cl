//{"buffer":0,"height":6,"image":1,"nbh":4,"nbw":3,"nsbw":2,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void downsample_full(global short* buffer, global unsigned char* image, unsigned int nsbw, unsigned int nbw, unsigned int nbh, unsigned int width, unsigned int height) {
  size_t gx = get_global_id(0);

  size_t super_block_id = gx >> 0x8;

  size_t super_block_x = super_block_id % nsbw;
  size_t super_block_y = super_block_id / nsbw;

  size_t sub_block_id = (gx & 0xFF) >> 0x6;
  size_t sub_block_x = sub_block_id & 0x1;
  size_t sub_block_y = sub_block_id >> 0x1;

  size_t field_id = gx & 0x3F;
  size_t field_x = field_id & 0x7;
  size_t field_y = field_id >> 0x3;

  size_t image_x = (super_block_x << 0x4) | (sub_block_x << 0x3) | field_x;
  size_t image_y = (super_block_y << 0x4) | (sub_block_y << 0x3) | field_y;

  if (image_x >= width)
    image_x = width - 1;
  if (image_y >= height)
    image_y = height - 1;

  buffer[hook(0, gx)] = (short)image[hook(1, (image_x + (image_y * width)) * 3)] - (short)0x80;
}