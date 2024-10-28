//{"in":2,"out":3,"pixelPitch":1,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(const unsigned int width, const int pixelPitch, global const unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int rowPitch = width * pixelPitch;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  int row0 = y * rowPitch;
  int row1 = row0 + rowPitch;
  int row2 = row1 + rowPitch;

  int r = (int)(-in[hook(2, row0 + ((x + 1) * pixelPitch) + 0)]

                - in[hook(2, row1 + ((x + 0) * pixelPitch) + 0)] + in[hook(2, row1 + ((x + 1) * pixelPitch) + 0)] * 4 - in[hook(2, row1 + ((x + 2) * pixelPitch) + 0)]

                - in[hook(2, row2 + ((x + 1) * pixelPitch) + 0)]);

  out[hook(3, row1 + ((x + 1) * pixelPitch) + 0)] = convert_uchar_sat(r);

  int g = (int)(-in[hook(2, row0 + ((x + 1) * pixelPitch) + 1)]

                - in[hook(2, row1 + ((x + 0) * pixelPitch) + 1)] + in[hook(2, row1 + ((x + 1) * pixelPitch) + 1)] * 4 - in[hook(2, row1 + ((x + 2) * pixelPitch) + 1)]

                - in[hook(2, row2 + ((x + 1) * pixelPitch) + 1)]);

  out[hook(3, row1 + ((x + 1) * pixelPitch) + 1)] = convert_uchar_sat(g);

  int b = (int)(-in[hook(2, row0 + ((x + 1) * pixelPitch) + 2)]

                - in[hook(2, row1 + ((x + 0) * pixelPitch) + 2)] + in[hook(2, row1 + ((x + 1) * pixelPitch) + 2)] * 4 - in[hook(2, row1 + ((x + 2) * pixelPitch) + 2)]

                - in[hook(2, row2 + ((x + 1) * pixelPitch) + 2)]);

  out[hook(3, row1 + ((x + 1) * pixelPitch) + 2)] = convert_uchar_sat(b);
}