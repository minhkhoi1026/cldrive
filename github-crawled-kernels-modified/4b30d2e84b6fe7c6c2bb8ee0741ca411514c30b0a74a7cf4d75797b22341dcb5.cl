//{"accu":3,"arg":7,"buffer":4,"height":2,"in":0,"key":8,"width":1,"xtrans":6,"xtrans[row % 6]":5}
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

float GAUSS(float center, float wings, float x) {
  const float b = -1.0f + center * 2.0f;
  const float c = (wings / 10.0f) / 2.0f;
  return exp(-(x - b) * (x - b) / (c * c));
}

typedef enum _channelmixer_output_t { CHANNEL_HUE = 0, CHANNEL_SATURATION, CHANNEL_LIGHTNESS, CHANNEL_RED, CHANNEL_GREEN, CHANNEL_BLUE, CHANNEL_GRAY, CHANNEL_SIZE } _channelmixer_output_t;

void encrypt_tea(unsigned int* arg) {
  const unsigned int key[] = {0xa341316c, 0xc8013ea4, 0xad90777d, 0x7e95761e};
  unsigned int v0 = arg[hook(7, 0)], v1 = arg[hook(7, 1)];
  unsigned int sum = 0;
  unsigned int delta = 0x9e3779b9;
  for (int i = 0; i < 8; i++) {
    sum += delta;
    v0 += ((v1 << 4) + key[hook(8, 0)]) ^ (v1 + sum) ^ ((v1 >> 5) + key[hook(8, 1)]);
    v1 += ((v0 << 4) + key[hook(8, 2)]) ^ (v0 + sum) ^ ((v0 >> 5) + key[hook(8, 3)]);
  }
  arg[hook(7, 0)] = v0;
  arg[hook(7, 1)] = v1;
}

float tpdf(unsigned int urandom) {
  float frandom = (float)urandom / 0xFFFFFFFFu;

  return (frandom < 0.5f ? (sqrt(2.0f * frandom) - 1.0f) : (1.0f - sqrt(2.0f * (1.0f - frandom))));
}

kernel void pixelmax_first(read_only image2d_t in, const int width, const int height, global float* accu, local float* buffer) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int xlsz = get_local_size(0);
  const int ylsz = get_local_size(1);
  const int xlid = get_local_id(0);
  const int ylid = get_local_id(1);

  const int l = ylid * xlsz + xlid;

  buffer[hook(4, l)] = (x < width && y < height) ? read_imagef(in, sampleri, (int2)(x, y)).x : -(__builtin_inff());

  barrier(0x01);

  const int lsz = mul24(xlsz, ylsz);

  for (int offset = lsz / 2; offset > 0; offset = offset / 2) {
    if (l < offset) {
      float other = buffer[hook(4, l + offset)];
      float mine = buffer[hook(4, l)];
      buffer[hook(4, l)] = (mine > other) ? mine : other;
    }
    barrier(0x01);
  }

  const int xgid = get_group_id(0);
  const int ygid = get_group_id(1);
  const int xgsz = get_num_groups(0);

  const int m = mad24(ygid, xgsz, xgid);
  accu[hook(3, m)] = buffer[hook(4, 0)];
}