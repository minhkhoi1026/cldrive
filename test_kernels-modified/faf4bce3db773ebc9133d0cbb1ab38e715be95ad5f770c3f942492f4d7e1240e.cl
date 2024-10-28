//{"buffer":3,"input":0,"length":2,"result":1,"xtrans":5,"xtrans[row % 6]":4}
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
int2 backtransformi(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (int2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

float2 backtransformf(float2 p, const int r_x, const int r_y, const int r_wd, const int r_ht, const float r_scale) {
  return (float2)((p.x + r_x) / r_scale, (p.y + r_y) / r_scale);
}

kernel void green_equilibration_favg_reduce_second(const global float2* input, global float2* result, const int length, local float2* buffer) {
  int x = get_global_id(0);
  float2 sum = (float2)0.0f;

  while (x < length) {
    sum += input[hook(0, x)];

    x += get_global_size(0);
  }

  int lid = get_local_id(0);
  buffer[hook(3, lid)] = sum;

  barrier(0x01);

  for (int offset = get_local_size(0) / 2; offset > 0; offset = offset / 2) {
    if (lid < offset) {
      buffer[hook(3, lid)] += buffer[hook(3, lid + offset)];
    }
    barrier(0x01);
  }

  if (lid == 0) {
    const int gid = get_group_id(0);

    result[hook(1, gid)] = buffer[hook(3, 0)];
  }
}