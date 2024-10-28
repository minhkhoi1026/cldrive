//{"dst_img":4,"height":6,"previewBuffer":7,"src_img1":0,"src_img2":2,"w1":1,"w2":3,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct PreviewObject {
  float f1;
  float f2;
  float f3;
};

kernel void image_sum(global uchar* src_img1, float w1, global uchar* src_img2, float w2, global uchar* dst_img, unsigned int width, unsigned int height, global struct PreviewObject* previewBuffer) {
  int2 blocks = (int2)(ceil((float)width / get_global_size(0)), ceil((float)height / get_global_size(1)));
  int2 image_coord = (int2)(blocks.x * get_global_id(0), blocks.y * get_global_id(1));

  for (int j = 0; j < blocks.y; j++) {
    image_coord.x = blocks.x * get_global_id(0);

    for (int i = 0; i < blocks.x; i++) {
      if (image_coord.x < width && image_coord.y < height) {
        uchar4 upixel1 = vload4(image_coord.y * width + image_coord.x, src_img1);
        float4 pixel1 = convert_float4(upixel1);

        uchar4 upixel2 = vload4(image_coord.y * width + image_coord.x, src_img2);
        float4 pixel2 = convert_float4(upixel2);
        float4 result = pixel1 * w1 + pixel2 * w2;
        uchar4 out = convert_uchar4_sat_rte(result);

        vstore4(out, image_coord.y * width + image_coord.x, dst_img);
      }
      image_coord.x += 1;
    }
    image_coord.y += 1;
  }
}