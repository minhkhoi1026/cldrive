//{"accu":3,"buffer":7,"filters":4,"height":2,"in":0,"r_x":5,"r_y":6,"width":1,"xtrans":9,"xtrans[row % 6]":8}
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
  return xtrans[hook(9, row % 6)][hook(8, col % 6)];
}
int2 backtransformi(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (int2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

float2 backtransformf(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (float2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

kernel void green_equilibration_favg_reduce_first(read_only image2d_t in, const int width, const int height, global float2* accu, const unsigned int filters, const int r_x, const int r_y, local float2* buffer) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int xlsz = get_local_size(0);
  const int ylsz = get_local_size(1);
  const int xlid = get_local_id(0);
  const int ylid = get_local_id(1);

  const int l = mad24(ylid, xlsz, xlid);

  const int c = FC(y + r_y, x + r_x, filters);

  const int isinimage = (x < 2 * (width / 2) && y < 2 * (height / 2));
  const int isgreen1 = (c == 1 && !((y + r_y) & 1));
  const int isgreen2 = (c == 1 && ((y + r_y) & 1));

  float pixel = read_imagef(in, sampleri, (int2)(x, y)).x;

  buffer[hook(7, l)].x = isinimage && isgreen1 ? pixel : 0.0f;
  buffer[hook(7, l)].y = isinimage && isgreen2 ? pixel : 0.0f;

  barrier(0x01);

  const int lsz = mul24(xlsz, ylsz);

  for (int offset = lsz / 2; offset > 0; offset = offset / 2) {
    if (l < offset) {
      buffer[hook(7, l)] += buffer[hook(7, l + offset)];
    }
    barrier(0x01);
  }

  const int xgid = get_group_id(0);
  const int ygid = get_group_id(1);
  const int xgsz = get_num_groups(0);

  const int m = mad24(ygid, xgsz, xgid);
  accu[hook(3, m)] = buffer[hook(7, 0)];
}