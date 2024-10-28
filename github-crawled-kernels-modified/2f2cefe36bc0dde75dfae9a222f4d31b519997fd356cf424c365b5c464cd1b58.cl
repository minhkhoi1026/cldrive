//{"divider":7,"dst_img":1,"height":3,"kw":4,"matrix":5,"matrix_size":6,"previewBuffer":8,"src_img":0,"width":2}
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

kernel void image_convolution(global uchar* src_img, global uchar* dst_img, unsigned int width, unsigned int height, global float* kw, local float* matrix, unsigned int matrix_size, float divider, global struct PreviewObject* previewBuffer) {
  event_t event = async_work_group_copy(matrix, kw, matrix_size * matrix_size, 0);

  int r = matrix_size >> 1;

  int2 blocks = (int2)(ceil((float)width / get_global_size(0)), ceil((float)height / get_global_size(1)));
  int2 start_image_coord = (int2)(blocks.x * get_global_id(0) - r, blocks.y * get_global_id(1) - r);
  int2 end_image_coord = (int2)(blocks.x * get_global_id(0) + r, blocks.y * get_global_id(1) + r);
  int2 out_image_coord = (int2)(blocks.x * get_global_id(0), blocks.y * get_global_id(1));

  unsigned int w = width + 2 * r;

  wait_group_events(1, &event);
  for (int j = 0; j < blocks.y; j++) {
    start_image_coord.x = blocks.x * get_global_id(0) - r;
    end_image_coord.x = blocks.x * get_global_id(0) + r;
    out_image_coord.x = blocks.x * get_global_id(0);

    for (int i = 0; i < blocks.x; i++) {
      if (out_image_coord.x < width && out_image_coord.y < height) {
        float4 result = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
        if (matrix_size == 3) {
          int2 sic = (int2)(start_image_coord.x + r, start_image_coord.y + r);
          int2 oic = (int2)(out_image_coord.x + r, out_image_coord.y + r);
          int2 eic = (int2)(end_image_coord.x + r, end_image_coord.y + r);
          result += convert_float4(vload4(sic.y * w + sic.x, src_img)) * matrix[hook(5, 0)];
          result += convert_float4(vload4(sic.y * w + oic.x, src_img)) * matrix[hook(5, 1)];
          result += convert_float4(vload4(sic.y * w + eic.x, src_img)) * matrix[hook(5, 2)];
          result += convert_float4(vload4(oic.y * w + sic.x, src_img)) * matrix[hook(5, 3)];
          result += convert_float4(vload4(oic.y * w + oic.x, src_img)) * matrix[hook(5, 4)];
          result += convert_float4(vload4(oic.y * w + eic.x, src_img)) * matrix[hook(5, 5)];
          result += convert_float4(vload4(eic.y * w + sic.x, src_img)) * matrix[hook(5, 6)];
          result += convert_float4(vload4(eic.y * w + oic.x, src_img)) * matrix[hook(5, 7)];
          result += convert_float4(vload4(eic.y * w + eic.x, src_img)) * matrix[hook(5, 8)];
          result = fabs(result / divider);
        } else {
          for (int y = start_image_coord.y; y <= end_image_coord.y; y++) {
            for (int x = start_image_coord.x; x <= end_image_coord.x; x++) {
              uchar4 in = vload4((y + r) * w + x + r, src_img);
              float4 fin = convert_float4(in);
              result += fin * matrix[hook(5, (y - start_image_coord.y) * matrix_size + (x - start_image_coord.x))];
            }
          }
          result = fabs(result / divider);
        }
        uchar4 out = convert_uchar4_sat_rte(result);

        vstore4(out, out_image_coord.y * width + out_image_coord.x, dst_img);
      }
      start_image_coord.x += 1;
      end_image_coord.x += 1;
      out_image_coord.x += 1;
    }
    start_image_coord.y += 1;
    end_image_coord.y += 1;
    out_image_coord.y += 1;
  }
}