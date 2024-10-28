//{"buffer":1,"dst_offset":9,"factor_offset":8,"flow_stride":6,"h":5,"image_stride":7,"src":0,"time_scale":10,"u":2,"v":3,"w":4}
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

kernel void forwardWarpKernel(global const float* src, global float* buffer, global const float* u, global const float* v, const int w, const int h, const int flow_stride, const int image_stride, const int factor_offset, const int dst_offset, const float time_scale) {
  int j = get_global_id(0);
  int i = get_global_id(1);

  if (i >= h || j >= w)
    return;

  volatile global float* normalization_factor = (volatile global float*)buffer + factor_offset;
  volatile global float* dst = (volatile global float*)buffer + dst_offset;

  int flow_row_offset = i * flow_stride;
  int image_row_offset = i * image_stride;

  float cx = u[hook(2, flow_row_offset + j)] * time_scale + (float)j + 1.0f;
  float cy = v[hook(3, flow_row_offset + j)] * time_scale + (float)i + 1.0f;

  float px;
  float py;
  float dx = modf(cx, &px);
  float dy = modf(cy, &py);

  int tx;
  int ty;
  tx = (int)px;
  ty = (int)py;
  float value = src[hook(0, image_row_offset + j)];
  float weight;

  if (!((tx >= w) || (tx < 0) || (ty >= h) || (ty < 0))) {
    weight = dx * dy;
    atomic_addf(dst + ty * image_stride + tx, value * weight);
    atomic_addf(normalization_factor + ty * image_stride + tx, weight);
  }

  tx -= 1;
  if (!((tx >= w) || (tx < 0) || (ty >= h) || (ty < 0))) {
    weight = (1.0f - dx) * dy;
    atomic_addf(dst + ty * image_stride + tx, value * weight);
    atomic_addf(normalization_factor + ty * image_stride + tx, weight);
  }

  ty -= 1;
  if (!((tx >= w) || (tx < 0) || (ty >= h) || (ty < 0))) {
    weight = (1.0f - dx) * (1.0f - dy);
    atomic_addf(dst + ty * image_stride + tx, value * weight);
    atomic_addf(normalization_factor + ty * image_stride + tx, weight);
  }

  tx += 1;
  if (!((tx >= w) || (tx < 0) || (ty >= h) || (ty < 0))) {
    weight = dx * (1.0f - dy);
    atomic_addf(dst + ty * image_stride + tx, value * weight);
    atomic_addf(normalization_factor + ty * image_stride + tx, weight);
  }
}