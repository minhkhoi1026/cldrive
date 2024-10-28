//{"blocksize":4,"buffer":5,"height":3,"in":0,"out":1,"width":2,"xtrans":7,"xtrans[row % 6]":6}
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
  return xtrans[hook(7, row % 6)][hook(6, col % 6)];
}
kernel void gaussian_transpose_1c(global float* in, global float* out, unsigned int width, unsigned int height, unsigned int blocksize, local float* buffer) {
  unsigned int x = get_global_id(0);
  unsigned int y = get_global_id(1);

  if ((x < width) && (y < height)) {
    const unsigned int iindex = mad24(y, width, x);
    buffer[hook(5, mad24(get_local_id(1), blocksize + 1, get_local_id(0)))] = in[hook(0, iindex)];
  }

  barrier(0x01);

  x = mad24(get_group_id(1), blocksize, get_local_id(0));
  y = mad24(get_group_id(0), blocksize, get_local_id(1));

  if ((x < height) && (y < width)) {
    const unsigned int oindex = mad24(y, height, x);
    out[hook(1, oindex)] = buffer[hook(5, mad24(get_local_id(0), blocksize + 1, get_local_id(1)))];
  }
}