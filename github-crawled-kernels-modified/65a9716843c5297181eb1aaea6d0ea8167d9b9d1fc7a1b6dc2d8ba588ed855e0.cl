//{"in":1,"out":2,"width":0,"yx":4,"yx[0]":5,"yx[1]":6,"yx[2]":7,"yx[dY]":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clCode(const unsigned int width, global const uchar4* in, global uchar4* out) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  int4 yx[3][3];

  for (int dY = 0; dY < 3; dY++)
    for (int dX = 0; dX < 3; dX++)
      yx[hook(4, dY)][hook(3, dX)] = convert_int4(in[hook(1, (y + dY) * width + (x + dX))]);

  int4 bgra = +yx[hook(4, 0)][hook(5, 0)] + yx[hook(4, 0)][hook(5, 1)] + yx[hook(4, 0)][hook(5, 2)]

              + yx[hook(4, 1)][hook(6, 0)] + yx[hook(4, 1)][hook(6, 1)] + yx[hook(4, 1)][hook(6, 2)]

              + yx[hook(4, 2)][hook(7, 0)] + yx[hook(4, 2)][hook(7, 1)] + yx[hook(4, 2)][hook(7, 2)];

  bgra /= 9;

  bgra.w = in[hook(1, (y + 1) * width + (x + 1))].w;

  out[hook(2, (y + 1) * width + (x + 1))] = convert_uchar4_sat(bgra);
}