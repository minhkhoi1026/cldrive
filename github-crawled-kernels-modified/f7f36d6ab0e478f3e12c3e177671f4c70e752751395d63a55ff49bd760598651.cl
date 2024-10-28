//{"p_backBuffer":1,"p_height":3,"p_iter":4,"p_screenBuffer":0,"p_width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void postx(global unsigned int* p_screenBuffer, global unsigned int* p_backBuffer, int p_width, int p_height, int p_iter) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x >= (p_width >> p_iter))
    return;
  if (y >= (p_height >> p_iter))
    return;

  int of_read = x * 2 + y * 2 * p_width + (p_width >> (p_iter));

  if (p_iter == 0)
    of_read -= p_width;

  int of_xy_read = of_read + (p_height / 2) * p_width;
  int of_write = x + y * p_width + (p_width >> (p_iter + 1));
  int of_xy_write = of_write + (p_height / 2) * p_width;

  int a1, a2, a3, a4;

  if (p_iter > 0) {
    a1 = p_backBuffer[hook(1, of_read)];
    a2 = p_backBuffer[hook(1, of_read + 1)];
    a3 = p_backBuffer[hook(1, of_read + p_width)];
    a4 = p_backBuffer[hook(1, of_read + 1 + p_width)];
  } else {
    a1 = p_screenBuffer[hook(0, of_read)];
    a2 = p_screenBuffer[hook(0, of_read + 1)];
    a3 = p_screenBuffer[hook(0, of_read + p_width)];
    a4 = p_screenBuffer[hook(0, of_read + 1 + p_width)];
  }

  int xy = 0;

  if (p_iter == 0) {
    int xo = 0, yo = 0;
    if (a2 < a1) {
      a1 = a2;
      xo = 1;
      yo = 0;
    }
    if (a3 < a1) {
      a1 = a3;
      xo = 0;
      yo = 1;
    }
    if (a4 < a1) {
      a1 = a4;
      xo = 1;
      yo = 1;
    }
    xo += x * 2;
    yo += y * 2;
    int scale = (a1 > 712 * 512) ? 1200 : 800;
    int radius = (p_width * scale / ((a1 & 0xffff00) + 2));
    if (radius > 255)
      radius = 255;
    xy = (xo << 8) + (yo << 20) + radius;
  } else {
    int ofs = 0;
    if (a2 < a1) {
      a1 = a2;
      ofs = 1;
    }
    if (a3 < a1) {
      a1 = a3;
      ofs = p_width;
    }
    if (a4 < a1) {
      a1 = a4;
      ofs = 1 + p_width;
    }

    xy = p_backBuffer[hook(1, of_xy_read + ofs)];
  }
  p_backBuffer[hook(1, of_write)] = a1;
  p_backBuffer[hook(1, of_xy_write)] = xy;
}