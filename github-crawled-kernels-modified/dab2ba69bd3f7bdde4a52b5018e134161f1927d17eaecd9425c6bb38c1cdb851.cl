//{"border":4,"count":11,"filters":7,"height":3,"in":0,"o":12,"out":1,"r_x":5,"r_y":6,"sum":10,"width":2,"xtrans":8,"xtrans[row % 6]":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampleri = 0 | 2 | 0x10;
constant sampler_t samplerf = 0 | 2 | 0x20;
constant sampler_t samplerc = 0 | 4 | 0x10;
int FC(const int row, const int col, const unsigned int filters) {
  return filters >> ((((row) << 1 & 14) + ((col)&1)) << 1) & 3;
}

int FCxtrans(const int row, const int col, global const unsigned char (*const xtrans)[6]) {
  return xtrans[hook(8, row % 6)][hook(9, col % 6)];
}

int fcol(const int row, const int col, const unsigned int filters, global const unsigned char (*const xtrans)[6]) {
  if (filters == 9)

    return FCxtrans(row + 6, col + 6, xtrans);
  else
    return FC(row, col, filters);
}

kernel void vng_border_interpolate(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const int border, const int r_x, const int r_y, const unsigned int filters, global const unsigned char (*const xtrans)[6]) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  const int colors = (filters == 9) ? 3 : 4;
  const int avgwindow = 1;

  if (x >= border && x < width - border && y >= border && y < height - border)
    return;

  float o[4] = {0.0f};
  float sum[4] = {0.0f};
  int count[4] = {0};

  for (int j = y - avgwindow; j <= y + avgwindow; j++)
    for (int i = x - avgwindow; i <= x + avgwindow; i++) {
      if (j >= 0 && i >= 0 && j < height && i < width) {
        int f = fcol(j + r_y, i + r_x, filters, xtrans);
        sum[hook(10, f)] += read_imagef(in, sampleri, (int2)(i, j)).x;
        count[hook(11, f)]++;
      }
    }

  float i = read_imagef(in, sampleri, (int2)(x, y)).x;

  int f = fcol(y + r_y, x + r_x, filters, xtrans);

  for (int c = 0; c < colors; c++) {
    if (c != f && count[hook(11, c)] != 0)
      o[hook(12, c)] = sum[hook(10, c)] / count[hook(11, c)];
    else
      o[hook(12, c)] = i;
  }

  write_imagef(out, (int2)(x, y), (float4)(o[hook(12, 0)], o[hook(12, 1)], o[hook(12, 2)], o[hook(12, 3)]));
}