//{"buffer":2,"h":5,"o0":12,"o1":13,"out":3,"step":6,"tex_src0":0,"tex_src1":1,"theta":7,"u":8,"ur":10,"v":9,"vr":11,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x20;
inline void atomic_addf(volatile global float* source, const float operand) {
  union {
    unsigned int intVal;
    float floatVal;
  } newVal;
  union {
    unsigned int intVal;
    float floatVal;
  } prevVal;
  do {
    prevVal.floatVal = *source;
    newVal.floatVal = prevVal.floatVal + operand;
  } while (atomic_cmpxchg((volatile global unsigned int*)source, prevVal.intVal, newVal.intVal) != prevVal.intVal);
}

enum { O0_OS = 0, O1_OS, U_OS, V_OS, UR_OS, VR_OS };

kernel void blendFramesKernel(image2d_t tex_src0, image2d_t tex_src1, global float* buffer, global float* out, int w, int h, int step, float theta) {
  global float* u = buffer + h * step * U_OS;
  global float* v = buffer + h * step * V_OS;
  global float* ur = buffer + h * step * UR_OS;
  global float* vr = buffer + h * step * VR_OS;
  global float* o0 = buffer + h * step * O0_OS;
  global float* o1 = buffer + h * step * O1_OS;

  int ix = get_global_id(0);
  int iy = get_global_id(1);

  if (ix >= w || iy >= h)
    return;

  int pos = ix + step * iy;

  float _u = u[hook(8, pos)];
  float _v = v[hook(9, pos)];

  float _ur = ur[hook(10, pos)];
  float _vr = vr[hook(11, pos)];

  float x = (float)ix + 0.5f;
  float y = (float)iy + 0.5f;
  bool b0 = o0[hook(12, pos)] > 1e-4f;
  bool b1 = o1[hook(13, pos)] > 1e-4f;

  float2 coord0 = (float2)(x - _u * theta, y - _v * theta);
  float2 coord1 = (float2)(x + _u * (1.0f - theta), y + _v * (1.0f - theta));

  if (b0 && b1) {
    out[hook(3, pos)] = read_imagef(tex_src0, sampler, coord0).x * (1.0f - theta) + read_imagef(tex_src1, sampler, coord1).x * theta;
  } else if (b0) {
    out[hook(3, pos)] = read_imagef(tex_src0, sampler, coord0).x;
  } else {
    out[hook(3, pos)] = read_imagef(tex_src1, sampler, coord1).x;
  }
}