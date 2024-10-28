//{"U_buf":5,"U_stride":2,"V_buf":6,"V_stride":3,"Y_buf":4,"Y_stride":1,"src_image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rgb_to_yuv444_601_limited(read_only image2d_t src_image, private unsigned int const Y_stride, private unsigned int const U_stride, private unsigned int const V_stride, global uchar* const Y_buf, global uchar* const U_buf, global uchar* const V_buf) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));

  float4 pixel = read_imagef(src_image, coords);
  float Y = 16 + pixel.x * 65.481 + pixel.y * 128.553 + pixel.z * 24.966;
  float U = 128 - pixel.x * 37.797 - pixel.y * 74.203 + pixel.z * 112.0;
  float V = 128 + pixel.x * 112.0 - pixel.y * 93.786 - pixel.z * 18.214;

  coords.y = get_image_height(src_image) - coords.y - 1;

  Y_buf[hook(4, coords.y * Y_stride + coords.x)] = round(Y);
  U_buf[hook(5, coords.y * U_stride + coords.x)] = round(U);
  V_buf[hook(6, coords.y * V_stride + coords.x)] = round(V);
}