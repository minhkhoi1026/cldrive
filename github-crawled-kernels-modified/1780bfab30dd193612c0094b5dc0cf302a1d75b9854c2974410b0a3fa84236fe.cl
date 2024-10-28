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

  for (int rgb = 0; rgb < 3; rgb++) {
    int data = 0;
    for (int dY = 0; dY < 3; dY++)
      for (int dX = 0; dX < 3; dX++)
        data += (int)in[hook(2, (y + dY) * rowPitch + (x + dX) * pixelPitch + rgb)];

    data /= 9;

    out[hook(3, rowPitch * (y + 1) + (x + 1) * pixelPitch + rgb)] = data;
  }
}