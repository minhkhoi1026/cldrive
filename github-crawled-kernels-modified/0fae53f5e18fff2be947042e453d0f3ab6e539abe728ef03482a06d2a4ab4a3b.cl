//{"grid":0,"height":2,"width":1,"xtrans":4,"xtrans[row % 6]":3}
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
  return xtrans[hook(4, row % 6)][hook(3, col % 6)];
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

kernel void colorreconstruction_zero(global float* grid, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x >= width || y >= height)
    return;
  grid[hook(0, y * width + x)] = 0.0f;
}