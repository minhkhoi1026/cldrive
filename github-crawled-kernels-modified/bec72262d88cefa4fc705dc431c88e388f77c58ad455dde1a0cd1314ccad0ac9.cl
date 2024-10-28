//{"in":2,"out":3,"pixelPitch":1,"width":0,"yx":5,"yx[0]":6,"yx[1]":7,"yx[2]":8,"yx[dY]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(const unsigned int width, const int pixelPitch, global const unsigned char* in, global unsigned char* out) {
  int yx[3][3];

  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int rowPitch = width * pixelPitch;
  if (rowPitch % 4)
    rowPitch = rowPitch + (4 - (rowPitch % 4));

  for (int dY = 0; dY < 3; dY++)
    for (int dX = 0; dX < 3; dX++)
      yx[hook(5, dY)][hook(4, dX)] = (y + dY) * rowPitch + (x + dX) * pixelPitch;

  for (int rgb = 0; rgb < 3; rgb++) {
    int data = (int)(

        -in[hook(2, yx[0hook(5, 0)[0hook(6, 0) + rgb)] - in[hook(2, yx[0hook(5, 0)[1hook(6, 1) + rgb)] - in[hook(2, yx[0hook(5, 0)[2hook(6, 2) + rgb)]

        - in[hook(2, yx[1hook(5, 1)[0hook(7, 0) + rgb)] + in[hook(2, yx[1hook(5, 1)[1hook(7, 1) + rgb)] * 9 - in[hook(2, yx[1hook(5, 1)[2hook(7, 2) + rgb)]

        - in[hook(2, yx[2hook(5, 2)[0hook(8, 0) + rgb)] - in[hook(2, yx[2hook(5, 2)[1hook(8, 1) + rgb)] - in[hook(2, yx[2hook(5, 2)[2hook(8, 2) + rgb)]);

    out[hook(3, yx[1hook(5, 1)[1hook(7, 1) + rgb)] = convert_uchar_sat(data);
  }
}