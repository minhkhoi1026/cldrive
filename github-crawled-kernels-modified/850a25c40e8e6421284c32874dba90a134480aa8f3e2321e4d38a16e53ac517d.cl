//{"gamma":4,"image":0,"rgbabuffer":1,"vmax":3,"vmin":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void buffer_render_2df(global float* image, global uchar* rgbabuffer, float vmin, float vmax, float gamma) {
  const int width = get_global_size(0);
  const int height = get_global_size(1);

  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int i = x + width * y;

  float value = clamp(native_powr((image[hook(0, i)] - vmin) / (vmax - vmin), gamma), 0.0f, 1.0f);

  uchar bytevalue = (uchar)(255 * value);

  vstore4((uchar4){bytevalue, bytevalue, bytevalue, 255}, i, rgbabuffer);
}