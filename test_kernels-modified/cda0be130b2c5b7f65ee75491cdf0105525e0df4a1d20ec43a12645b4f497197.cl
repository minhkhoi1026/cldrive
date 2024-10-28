//{"arg":6,"buffer":3,"input":0,"key":7,"length":2,"result":1,"xtrans":5,"xtrans[row % 6]":4}
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
  return xtrans[hook(5, row % 6)][hook(4, col % 6)];
}

float GAUSS(float center, float wings, float x) {
  const float b = -1.0f + center * 2.0f;
  const float c = (wings / 10.0f) / 2.0f;
  return exp(-(x - b) * (x - b) / (c * c));
}

typedef enum _channelmixer_output_t { CHANNEL_HUE = 0, CHANNEL_SATURATION, CHANNEL_LIGHTNESS, CHANNEL_RED, CHANNEL_GREEN, CHANNEL_BLUE, CHANNEL_GRAY, CHANNEL_SIZE } _channelmixer_output_t;

void encrypt_tea(unsigned int* arg) {
  const unsigned int key[] = {0xa341316c, 0xc8013ea4, 0xad90777d, 0x7e95761e};
  unsigned int v0 = arg[hook(6, 0)], v1 = arg[hook(6, 1)];
  unsigned int sum = 0;
  unsigned int delta = 0x9e3779b9;
  for (int i = 0; i < 8; i++) {
    sum += delta;
    v0 += ((v1 << 4) + key[hook(7, 0)]) ^ (v1 + sum) ^ ((v1 >> 5) + key[hook(7, 1)]);
    v1 += ((v0 << 4) + key[hook(7, 2)]) ^ (v0 + sum) ^ ((v0 >> 5) + key[hook(7, 3)]);
  }
  arg[hook(6, 0)] = v0;
  arg[hook(6, 1)] = v1;
}

float tpdf(unsigned int urandom) {
  float frandom = (float)urandom / (float)0xFFFFFFFFu;

  return (frandom < 0.5f ? (sqrt(2.0f * frandom) - 1.0f) : (1.0f - sqrt(2.0f * (1.0f - frandom))));
}

kernel void pixelmax_second(global float* input, global float* result, const int length, local float* buffer) {
  int x = get_global_id(0);
  float accu = -(__builtin_inff());

  while (x < length) {
    float element = input[hook(0, x)];
    accu = (accu > element) ? accu : element;
    x += get_global_size(0);
  }

  int lid = get_local_id(0);
  buffer[hook(3, lid)] = accu;

  barrier(0x01);

  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (lid < offset) {
      float other = buffer[hook(3, lid + offset)];
      float mine = buffer[hook(3, lid)];
      buffer[hook(3, lid)] = (mine > other) ? mine : other;
    }
    barrier(0x01);
  }

  if (lid == 0) {
    result[hook(1, get_group_id(0))] = buffer[hook(3, 0)];
  }
}