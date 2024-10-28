//{"gs":3,"pixelPitch":1,"rgb":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void grayscale(const unsigned int width, const int pixelPitch, global const unsigned char* rgb, global unsigned char* gs) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int rowPitch = width * pixelPitch;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  int pos = y * rowPitch + x * pixelPitch;

  int data = (int)((float)rgb[hook(2, pos + 0)] * 0.114478f + (float)rgb[hook(2, pos + 1)] * 0.586611f + (float)rgb[hook(2, pos + 2)] * 0.298912f);

  gs[hook(3, (width * y) + x)] = convert_uchar_sat(data);
}