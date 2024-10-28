//{"blocksize":5,"buffer":6,"height":4,"in":0,"out":1,"rad":2,"width":3,"xtrans":8,"xtrans[row % 6]":7}
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
  return xtrans[hook(8, row % 6)][hook(7, col % 6)];
}

kernel void bloom_hblur(read_only image2d_t in, write_only image2d_t out, const int rad, const int width, const int height, const int blocksize, local float* buffer) {
  const int lid = get_local_id(0);
  const int lsz = get_local_size(0);
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  float pixel = 0.0f;

  pixel = read_imagef(in, sampleri, (int2)(x, y)).x;
  buffer[hook(6, rad + lid)] = pixel;

  for (int n = 0; n <= rad / lsz; n++) {
    const int l = mad24(n, lsz, lid + 1);
    if (l > rad)
      continue;
    const int xx = mad24((int)get_group_id(0), lsz, -l);
    buffer[hook(6, rad - l)] = read_imagef(in, sampleri, (int2)(xx, y)).x;
  }

  for (int n = 0; n <= rad / lsz; n++) {
    const int r = mad24(n, lsz, lsz - lid);
    if (r > rad)
      continue;
    const int xx = mad24((int)get_group_id(0), lsz, lsz - 1 + r);
    buffer[hook(6, rad + lsz - 1 + r)] = read_imagef(in, sampleri, (int2)(xx, y)).x;
  }

  barrier(0x01);

  if (x >= width || y >= height)
    return;

  buffer += lid + rad;

  float sum = 0.0f;

  for (int i = -rad; i <= rad; i++) {
    sum += buffer[hook(6, i)];
  }

  pixel = sum / (2 * rad + 1);
  write_imagef(out, (int2)(x, y), pixel);
}