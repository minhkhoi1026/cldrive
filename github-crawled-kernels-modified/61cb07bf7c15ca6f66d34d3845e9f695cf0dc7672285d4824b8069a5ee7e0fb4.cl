//{"ibuf":0,"obuf":1,"offset1":2,"offset2":3,"offset3":4,"size1":5,"size2":6,"size3":7,"xtrans":9,"xtrans[row % 6]":8}
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

kernel void colorreconstruction_blur_line(global const float* ibuf, global float* obuf, const int offset1, const int offset2, const int offset3, const int size1, const int size2, const int size3) {
  const int k = get_global_id(0);
  const int j = get_global_id(1);
  if (k >= size1 || j >= size2)
    return;

  const float w0 = 6.0f / 16.0f;
  const float w1 = 4.0f / 16.0f;
  const float w2 = 1.0f / 16.0f;
  int index = k * offset1 + j * offset2;

  float4 tmp1 = vload4(index, ibuf);
  float4 out = vload4(index, ibuf) * w0 + vload4(index + offset3, ibuf) * w1 + vload4(index + 2 * offset3, ibuf) * w2;
  vstore4(out, index, obuf);
  index += offset3;
  float4 tmp2 = vload4(index, ibuf);
  out = vload4(index, ibuf) * w0 + (vload4(index + offset3, ibuf) + tmp1) * w1 + vload4(index + 2 * offset3, ibuf) * w2;
  vstore4(out, index, obuf);
  index += offset3;
  for (int i = 2; i < size3 - 2; i++) {
    const float4 tmp3 = vload4(index, ibuf);
    out = vload4(index, ibuf) * w0 + (vload4(index + offset3, ibuf) + tmp2) * w1 + (vload4(index + 2 * offset3, ibuf) + tmp1) * w2;
    vstore4(out, index, obuf);
    index += offset3;
    tmp1 = tmp2;
    tmp2 = tmp3;
  }
  const float4 tmp3 = vload4(index, ibuf);
  out = vload4(index, ibuf) * w0 + (vload4(index + offset3, ibuf) + tmp2) * w1 + tmp1 * w2;
  vstore4(out, index, obuf);
  index += offset3;
  out = vload4(index, ibuf) * w0 + tmp3 * w1 + tmp2 * w2;
  vstore4(out, index, obuf);
}