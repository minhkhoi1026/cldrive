//{"buf":1,"src_image":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rgba_to_uint8_rgba_buffer(read_only image2d_t src_image, global uchar* const buf) {
  int2 coords = (int2)(get_global_id(0), get_global_id(1));
  int w = get_image_width(src_image);

  float4 pixel = read_imagef(src_image, coords) * 255.0f;

  int base = (coords.y * w + coords.x) * 4;
  buf[hook(1, base)] = round(pixel.x);
  buf[hook(1, base + 1)] = round(pixel.y);
  buf[hook(1, base + 2)] = round(pixel.z);
  buf[hook(1, base + 3)] = round(pixel.w);
}