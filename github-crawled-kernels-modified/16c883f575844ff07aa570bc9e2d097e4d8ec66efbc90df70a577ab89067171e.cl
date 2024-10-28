//{"count":8,"filters":4,"height":3,"in":0,"out":1,"sum":7,"width":2,"xtrans":6,"xtrans[row % 6]":5}
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
  return xtrans[hook(6, row % 6)][hook(5, col % 6)];
}
int2 backtransformi(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (int2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

float2 backtransformf(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (float2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

constant int glim[5] = {0, 1, 2, 1, 0};

kernel void border_interpolate(read_only image2d_t in, write_only image2d_t out, const int width, const int height, const unsigned int filters) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  if (x >= width || y >= height)
    return;

  int border = 3;
  int avgwindow = 1;

  if (x >= border && x < width - border && y >= border && y < height - border)
    return;

  float4 o;
  float sum[4] = {0.0f};
  int count[4] = {0};

  for (int j = y - avgwindow; j <= y + avgwindow; j++)
    for (int i = x - avgwindow; i <= x + avgwindow; i++) {
      if (j >= 0 && i >= 0 && j < height && i < width) {
        int f = FC(j, i, filters);
        sum[hook(7, f)] += read_imagef(in, sampleri, (int2)(i, j)).x;
        count[hook(8, f)]++;
      }
    }

  float i = read_imagef(in, sampleri, (int2)(x, y)).x;
  o.x = count[hook(8, 0)] > 0 ? sum[hook(7, 0)] / count[hook(8, 0)] : i;
  o.y = count[hook(8, 1)] + count[hook(8, 3)] > 0 ? (sum[hook(7, 1)] + sum[hook(7, 3)]) / (count[hook(8, 1)] + count[hook(8, 3)]) : i;
  o.z = count[hook(8, 2)] > 0 ? sum[hook(7, 2)] / count[hook(8, 2)] : i;

  int f = FC(y, x, filters);

  if (f == 0)
    o.x = i;
  else if (f == 1)
    o.y = i;
  else if (f == 2)
    o.z = i;
  else
    o.y = i;

  write_imagef(out, (int2)(x, y), o);
}