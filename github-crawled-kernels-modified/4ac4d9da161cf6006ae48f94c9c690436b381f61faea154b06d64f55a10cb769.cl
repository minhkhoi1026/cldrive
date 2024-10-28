//{"p_backBuffer":1,"p_height":3,"p_iter":4,"p_screenBuffer":0,"p_width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void posty(global unsigned int* p_screenBuffer, global unsigned int* p_backBuffer, int p_width, int p_height, int p_iter) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x >= (p_width >> 1))
    return;
  if (x >= (p_width >> p_iter))
    return;
  if (y >= (p_height >> p_iter))
    return;

  int x_max = p_width >> p_iter;
  int y_max = p_height >> p_iter;

  int xy_of = (p_height / 2) * p_width;

  int of_read = (x / 2) + (y / 2) * p_width + (p_width >> (p_iter + 1));

  int of_xy_read = of_read + xy_of;

  int of_write = x + y * p_width + (p_width >> p_iter);

  if (p_iter == 0)
    of_write -= p_width;

  int of_xy_write = of_write + xy_of;

  int xy2, x2, y2, z2, r2;

  if (p_iter == 0) {
    x2 = x;
    y2 = y;
    z2 = p_screenBuffer[hook(0, of_write)];
    int scale = (z2 > 512 * 512) ? 1200 : 800;
    r2 = (p_width * scale / ((z2 & 0xffff00) + 2));
  } else {
    xy2 = p_backBuffer[hook(1, of_xy_write)];
    x2 = (xy2 >> 8) & 4095;
    y2 = xy2 >> 20;
    z2 = p_backBuffer[hook(1, of_write)];
    r2 = xy2 & 255;
  }

  int px = x << p_iter;
  int py = y << p_iter;
  if (p_iter > 0) {
    px += 1 << (p_iter - 1);
    py += 1 << (p_iter - 1);
  }

  int zmin = 0xffffff;

  float sumx = 0;
  float sumy = 0;
  float sumz = 0;
  float sumc = 0;
  float sumr = 0;
  float sum = 0;
  int sumcc = 0;

  for (int i = -2; i < 3; ++i)
    if (i + x / 2 >= 0)
      if (i + x / 2 < x_max)
        for (int j = -2; j < 3; ++j)
          if (j + y / 2 >= 0)
            if (j + y / 2 < y_max) {
              int add = i + j * p_width;
              int xy1 = p_backBuffer[hook(1, of_xy_read + add)];
              int x1 = (xy1 >> 8) & 4095;
              int y1 = xy1 >> 20;
              int z1 = p_backBuffer[hook(1, of_read + add)];
              int r1 = xy1 & 255;

              float r = sqrt(convert_float((x1 - px) * (x1 - px) + (y1 - py) * (y1 - py)));

              if (r1 > r)
                if ((z1 & 0xffff00) < zmin) {
                  zmin = z1 & 0xffff00;
                  sumcc = z1 & 3;
                }
            }

  for (int i = -2; i < 3; ++i)
    if (i + x / 2 >= 0)
      if (i + x / 2 < x_max)
        for (int j = -2; j < 3; ++j)
          if (j + y / 2 >= 0)
            if (j + y / 2 < y_max) {
              int add = i + j * p_width;
              int xy1 = p_backBuffer[hook(1, of_xy_read + add)];
              int x1 = (xy1 >> 8) & 4095;
              int y1 = xy1 >> 20;
              int z1 = p_backBuffer[hook(1, of_read + add)];
              int r1 = xy1 & 255;

              float r = sqrt(convert_float((x1 - px) * (x1 - px) + (y1 - py) * (y1 - py)));

              if (sumc == 255)
                sumc = (z1 & 0xff);

              if (r1 > r)
                if (abs((z1 & 0xffff00) - zmin) < (4 * 256)) {
                  float cmpr = r1;
                  float w = (fabs(r - cmpr));
                  ;
                  w *= w;
                  w += abs((z1 & 0xffff00) - zmin) / 256;
                  w += 1 / w;
                  sumx += w * convert_float(x1);
                  sumy += w * convert_float(y1);
                  sumz += w * convert_float(z1 & 0xffff00);
                  sumr += w * convert_float(r1);
                  sumc += w * convert_float(z1 & 255);
                  sum += w;
                }
            }
  if (sum > 0) {
    sumz /= sum;
    sumx /= sum;
    sumy /= sum;
    sumc /= sum;
    sumr /= sum;
    sum = 1;

    if (abs((z2 & 0xffff00) - (convert_int(sumz) & 0xffff00)) < (4 * 256)) {
      float w = 1;
      sumx += w * convert_float(x2);
      sumy += w * convert_float(y2);
      sumz += w * convert_float(z2 & 0xffff00);
      sumc += w * convert_float(z2 & 0xff);
      sumcc = z2 & 3;
      sumr += w * convert_float(r2);
      sum += w;
    }
    sumz /= sum;
    sumx /= sum;
    sumy /= sum;
    sumc /= sum;
    sumr /= sum;

    z2 = (convert_int(sumz) & 0xffff00) + (convert_int(sumc) & 0xfc) + (sumcc & 3);
    xy2 = convert_int(sumr) + (convert_int(sumx) << 8) + (convert_int(sumy) << 20);
  }

  if (p_iter == 0) {
    p_screenBuffer[hook(0, of_write)] = z2;

  } else {
    p_backBuffer[hook(1, of_write)] = z2;
    p_backBuffer[hook(1, of_xy_write)] = xy2;
  }
}