//{"accum":13,"gi":12,"grid":1,"height":3,"in":0,"params":11,"precedence":10,"sigma_r":8,"sigma_s":7,"sizex":4,"sizey":5,"sizez":6,"threshold":9,"width":2,"xtrans":15,"xtrans[row % 6]":14}
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
  return xtrans[hook(15, row % 6)][hook(14, col % 6)];
}

typedef enum dt_iop_colorreconstruct_precedence_t { COLORRECONSTRUCT_PRECEDENCE_NONE, COLORRECONSTRUCT_PRECEDENCE_CHROMA, COLORRECONSTRUCT_PRECEDENCE_HUE } dt_iop_colorreconstruct_precedence_t;

float4 image_to_grid(const float4 p, const int4 size, const float4 sigma) {
  return (float4)(clamp(p.x / sigma.x, 0.0f, size.x - 1.0f), clamp(p.y / sigma.y, 0.0f, size.y - 1.0f), clamp(p.z / sigma.z, 0.0f, size.z - 1.0f), 0.0f);
}

float2 grid_rescale(const int2 pxy, const int2 roixy, const int2 bxy, const float scale) {
  return convert_float2(roixy + pxy) * scale - convert_float2(bxy);
}

void atomic_add_f(global float* val, const float delta) {
  union {
    float f;
    unsigned int i;
  } old_val;
  union {
    float f;
    unsigned int i;
  } new_val;

  global volatile unsigned int* ival = (global volatile unsigned int*)val;

  do {
    old_val.i = atom_add(ival, 0);
    new_val.f = old_val.f + delta;
  } while (atom_cmpxchg(ival, old_val.i, new_val.i) != old_val.i);
}

kernel void colorreconstruction_splat(read_only image2d_t in, global float* grid, const int width, const int height, const int sizex, const int sizey, const int sizez, const float sigma_s, const float sigma_r, const float threshold, const int precedence, const float4 params, local int* gi, local float4* accum) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int lszx = get_local_size(0);
  const int i = get_local_id(0);
  const int j = get_local_id(1);
  int li = lszx * j + i;

  int4 size = (int4)(sizex, sizey, sizez, 0);
  float4 sigma = (float4)(sigma_s, sigma_s, sigma_r, 0);

  const float4 pixel = read_imagef(in, samplerc, (int2)(x, y));
  float weight, m;

  switch (precedence) {
    case COLORRECONSTRUCT_PRECEDENCE_CHROMA:
      weight = sqrt(pixel.y * pixel.y + pixel.z * pixel.z);
      break;

    case COLORRECONSTRUCT_PRECEDENCE_HUE:
      m = atan2(pixel.z, pixel.y) - params.x;

      m = m > 3.14159265358979323846264338327950288f ? m - 2 * 3.14159265358979323846264338327950288f : (m < -3.14159265358979323846264338327950288f ? m + 2 * 3.14159265358979323846264338327950288f : m);
      weight = exp(-m * m / params.y);
      break;

    case COLORRECONSTRUCT_PRECEDENCE_NONE:
    default:
      weight = 1.0f;
      break;
  }

  if (x < width && y < height) {
    float4 p = (float4)(x, y, pixel.x, 0);
    float4 gridp = image_to_grid(p, size, sigma);

    int4 xi = clamp(convert_int4(round(gridp)), 0, size - 1);

    gi[hook(12, li)] = xi.x + size.x * xi.y + size.x * size.y * xi.z;
    accum[hook(13, li)] = pixel.x < threshold ? weight * (float4)(pixel.x, pixel.y, pixel.z, 1.0f) : (float4)0.0f;
  } else {
    gi[hook(12, li)] = -1;
  }

  barrier(0x01);

  if (i != 0)
    return;

  li = lszx * j;
  int oldgi = gi[hook(12, li)];
  float4 tmp = accum[hook(13, li)];

  for (int ii = 1; ii < lszx && oldgi != -1; ii++) {
    li = lszx * j + ii;
    if (gi[hook(12, li)] != oldgi) {
      atomic_add_f(grid + 4 * oldgi, tmp.x);
      atomic_add_f(grid + 4 * oldgi + 1, tmp.y);
      atomic_add_f(grid + 4 * oldgi + 2, tmp.z);
      atomic_add_f(grid + 4 * oldgi + 3, tmp.w);

      oldgi = gi[hook(12, li)];
      tmp = accum[hook(13, li)];
    } else {
      tmp = accum[hook(13, li)];
    }
  }

  if (oldgi == -1)
    return;

  atomic_add_f(grid + 4 * oldgi, tmp.x);
  atomic_add_f(grid + 4 * oldgi + 1, tmp.y);
  atomic_add_f(grid + 4 * oldgi + 2, tmp.z);
  atomic_add_f(grid + 4 * oldgi + 3, tmp.w);
}