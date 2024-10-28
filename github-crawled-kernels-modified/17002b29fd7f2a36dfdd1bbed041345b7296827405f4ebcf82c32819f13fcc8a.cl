//{"gs":2,"pixelPitch":1,"rgb":3,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void filter(const unsigned int width, const int pixelPitch, global const unsigned char* gs, global unsigned char* rgb) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int row0 = (y + 0) * width;
  int row1 = (y + 1) * width;
  int row2 = (y + 2) * width;

  int hx = (int)(

      -gs[hook(2, row0 + x + 0)] + gs[hook(2, row0 + x + 2)]

      - gs[hook(2, row1 + x + 0)] + gs[hook(2, row1 + x + 2)]

      - gs[hook(2, row2 + x + 0)] + gs[hook(2, row2 + x + 2)]);

  int hy = (int)(

      -gs[hook(2, row0 + x + 0)] - gs[hook(2, row0 + x + 1)] - gs[hook(2, row0 + x + 2)]

      + gs[hook(2, row2 + x + 0)] + gs[hook(2, row2 + x + 1)] + gs[hook(2, row2 + x + 2)]);

  int rowPitch = width * pixelPitch;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  int pos = rowPitch * (y + 1) + pixelPitch * (x + 1);

  rgb[hook(3, pos + 0)] = rgb[hook(3, pos + 1)] = rgb[hook(3, pos + 2)] = convert_uchar_sat(hypot((float)hx, (float)hy));
}