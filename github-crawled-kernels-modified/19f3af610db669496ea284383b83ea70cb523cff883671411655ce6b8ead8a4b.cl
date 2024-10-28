//{"in":2,"out":3,"pixelPitch":1,"width":0,"yx":5,"yx[0]":6,"yx[1]":7,"yx[2]":8,"yx[dY]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(const unsigned int width, const int pixelPitch, global unsigned char* in, global unsigned char* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  global unsigned char* ptr;
  int3 yx[3][3];

  int rowPitch = width * pixelPitch;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  for (int dY = 0; dY < 3; dY++)
    for (int dX = 0; dX < 3; dX++) {
      ptr = in + (y + dY) * rowPitch + (x + dX) * pixelPitch;
      yx[hook(5, dY)][hook(4, dX)] = convert_int3(vload3(0, ptr));
    }

  int3 bgra = -yx[hook(5, 0)][hook(6, 0)] - yx[hook(5, 0)][hook(6, 1)] - yx[hook(5, 0)][hook(6, 2)]

              - yx[hook(5, 1)][hook(7, 0)] + yx[hook(5, 1)][hook(7, 1)] * 9 - yx[hook(5, 1)][hook(7, 2)]

              - yx[hook(5, 2)][hook(8, 0)] - yx[hook(5, 2)][hook(8, 1)] - yx[hook(5, 2)][hook(8, 2)];

  ptr = out + (y + 1) * rowPitch + (x + 1) * pixelPitch;
  vstore3(convert_uchar3_sat(bgra), 0, ptr);
}