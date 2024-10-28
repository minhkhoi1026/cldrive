//{"bxy":11,"grid":2,"height":4,"in":0,"out":1,"roixy":12,"scale":13,"sigma_r":9,"sigma_s":8,"sizex":5,"sizey":6,"sizez":7,"threshold":10,"width":3,"xtrans":15,"xtrans[row % 6]":14}
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

kernel void colorreconstruction_slice(read_only image2d_t in, write_only image2d_t out, global float* grid, const int width, const int height, const int sizex, const int sizey, const int sizez, const float sigma_s, const float sigma_r, const float threshold, const int2 bxy, const int2 roixy, const float scale) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x >= width || y >= height)
    return;

  const int ox = 1;
  const int oy = sizex;
  const int oz = sizey * sizex;

  int4 size = (int4)(sizex, sizey, sizez, 0);
  float4 sigma = (float4)(sigma_s, sigma_s, sigma_r, 0);

  float4 pixel = read_imagef(in, samplerc, (int2)(x, y));
  float blend = clamp(20.0f / threshold * pixel.x - 19.0f, 0.0f, 1.0f);
  float2 pxy = grid_rescale((int2)(x, y), roixy, bxy, scale);
  float4 p = (float4)(pxy.x, pxy.y, pixel.x, 0);
  float4 gridp = image_to_grid(p, size, sigma);
  int4 gridi = min(size - 2, (int4)(gridp.x, gridp.y, gridp.z, 0));
  float fx = gridp.x - gridi.x;
  float fy = gridp.y - gridi.y;
  float fz = gridp.z - gridi.z;

  const int gi = gridi.x + sizex * (gridi.y + sizey * gridi.z);
  const float4 opixel = vload4(gi, grid) * (1.0f - fx) * (1.0f - fy) * (1.0f - fz) + vload4(gi + ox, grid) * (fx) * (1.0f - fy) * (1.0f - fz) + vload4(gi + oy, grid) * (1.0f - fx) * (fy) * (1.0f - fz) + vload4(gi + ox + oy, grid) * (fx) * (fy) * (1.0f - fz) + vload4(gi + oz, grid) * (1.0f - fx) * (1.0f - fy) * (fz) + vload4(gi + ox + oz, grid) * (fx) * (1.0f - fy) * (fz) + vload4(gi + oy + oz, grid) * (1.0f - fx) * (fy) * (fz) + vload4(gi + ox + oy + oz, grid) * (fx) * (fy) * (fz);

  const float opixelx = fmax(opixel.x, 0.01f);
  pixel.y = (opixel.w > 0.0f) ? pixel.y * (1.0f - blend) + opixel.y * pixel.x / opixelx * blend : pixel.y;
  pixel.z = (opixel.w > 0.0f) ? pixel.z * (1.0f - blend) + opixel.z * pixel.x / opixelx * blend : pixel.z;

  write_imagef(out, (int2)(x, y), pixel);
}