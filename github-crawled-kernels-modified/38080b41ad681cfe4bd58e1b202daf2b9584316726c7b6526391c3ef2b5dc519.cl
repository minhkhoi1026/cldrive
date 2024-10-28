//{"cb":0,"cr":1,"height":7,"image":2,"nbh":5,"nbw":4,"nsbw":3,"width":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void downsample_2v2(global short* cb, global short* cr, global unsigned char* image, unsigned int nsbw, unsigned int nbw, unsigned int nbh, unsigned int width, unsigned int height) {
  size_t gx = get_global_id(0);

  size_t super_block_id = gx >> 0x6;

  size_t super_block_x = super_block_id % nsbw;
  size_t super_block_y = super_block_id / nsbw;

  size_t sub_block_x = (gx & 0x7) > 0x3;
  size_t sub_block_y = (gx & 0x3F) > 0x1F;

  size_t field_id = gx & 0x3F;
  size_t field_x = (field_id & 0x7) << 0x1;
  size_t field_y = (field_id >> 0x3) << 0x1;

  size_t image_x = (super_block_x << 0x4) | (sub_block_x << 0x3) | field_x;
  size_t image_y = (super_block_y << 0x4) | (sub_block_y << 0x3) | field_y;

  size_t pixel_x0 = image_x;
  size_t pixel_x1 = image_x + 1;
  size_t pixel_y0 = image_y;
  size_t pixel_y1 = image_y + 1;

  if (pixel_x0 >= width)
    pixel_x0 = width - 1;
  if (pixel_x1 >= width)
    pixel_x1 = width - 1;
  if (pixel_y0 >= height)
    pixel_y0 = height - 1;
  if (pixel_y1 >= height)
    pixel_y1 = height - 1;

  size_t pixel00 = (pixel_x0 + (pixel_y0 * width));
  size_t pixel10 = (pixel_x1 + (pixel_y0 * width));
  size_t pixel01 = (pixel_x0 + (pixel_y1 * width));
  size_t pixel11 = (pixel_x1 + (pixel_y1 * width));

  long cb_sum = 0;
  long cr_sum = 0;

  size_t pixel = pixel00 * 3;
  cb_sum += (long)image[hook(2, pixel + 1)];
  cr_sum += (long)image[hook(2, pixel + 2)];

  pixel = pixel10 * 3;
  cb_sum += (long)image[hook(2, pixel + 1)];
  cr_sum += (long)image[hook(2, pixel + 2)];

  pixel = pixel01 * 3;
  cb_sum += (long)image[hook(2, pixel + 1)];
  cr_sum += (long)image[hook(2, pixel + 2)];

  pixel = pixel11 * 3;
  cb_sum += (long)image[hook(2, pixel + 1)];
  cr_sum += (long)image[hook(2, pixel + 2)];

  int bias = 0x1 << (gx & 0x1);
  cb_sum += bias;
  cr_sum += bias;

  cb[hook(0, gx)] = (short)(cb_sum >> 0x2) - (short)0x80;
  cr[hook(1, gx)] = (short)(cr_sum >> 0x2) - (short)0x80;
}