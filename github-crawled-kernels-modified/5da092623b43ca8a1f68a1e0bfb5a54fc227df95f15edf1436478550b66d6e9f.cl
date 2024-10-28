//{"dstImage":0,"srcImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ImageCopy(write_only image2d_t dstImage, read_only image2d_t srcImage) {
  int work_group_pixel_offset = get_group_id(0) * get_enqueued_local_size(0) * 4;
  int work_item_pixel_offset = work_group_pixel_offset + get_local_id(0) * 4;

  for (unsigned int pixel = 0; pixel < 4; pixel++) {
    int2 coord = (int2)(work_item_pixel_offset + pixel, get_global_id(1));

    uint4 float3 = read_imageui(srcImage, coord);

    write_imageui(dstImage, coord, float3);
  }
}