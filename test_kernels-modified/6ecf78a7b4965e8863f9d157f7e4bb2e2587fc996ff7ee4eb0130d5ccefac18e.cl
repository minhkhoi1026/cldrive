//{"A":12,"accum":15,"b":13,"counter":5,"desc":16,"layer_in":8,"layer_out":2,"response_in":9,"response_out":3,"size_in":10,"size_out":4,"total_feat":11,"x":14,"x_in":6,"x_out":0,"y_in":7,"y_out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void gaussianElimination(float* A, float* b, float* x, const int n) {
  for (int i = 0; i < n - 1; i++) {
    for (int j = i + 1; j < n; j++) {
      float s = A[hook(12, j * n + i)] / A[hook(12, i * n + i)];

      for (int k = i; k < n; k++)
        A[hook(12, j * n + k)] -= s * A[hook(12, i * n + k)];

      b[hook(13, j)] -= s * b[hook(13, i)];
    }
  }

  for (int i = 0; i < n; i++)
    x[hook(14, i)] = 0;

  float sum = 0;
  for (int i = 0; i <= n - 2; i++) {
    sum = b[hook(13, i)];
    for (int j = i + 1; j < n; j++)
      sum -= A[hook(12, i * n + j)] * x[hook(14, j)];
    x[hook(14, i)] = sum / A[hook(12, i * n + i)];
  }
}

inline void fatomic_add(volatile local float* source, const float operand) {
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
  } while (atomic_cmpxchg((volatile local unsigned int*)source, prevVal.intVal, newVal.intVal) != prevVal.intVal);
}

inline void normalizeDesc(local float* desc, local float* accum, const int histlen, int lid_x, int lid_y, int lsz_x) {
  for (int i = lid_x; i < histlen; i += lsz_x)
    accum[hook(15, i)] = desc[hook(16, lid_y * histlen + i)] * desc[hook(16, lid_y * histlen + i)];
  barrier(0x01);

  float sum = 0.0f;
  for (int i = 0; i < histlen; i++)
    sum += desc[hook(16, lid_y * histlen + i)] * desc[hook(16, lid_y * histlen + i)];
  barrier(0x01);

  if (lid_x < 64)
    accum[hook(15, lid_x)] += accum[hook(15, lid_x + 64)];
  barrier(0x01);
  if (lid_x < 32)
    accum[hook(15, lid_x)] += accum[hook(15, lid_x + 32)];
  barrier(0x01);
  if (lid_x < 16)
    accum[hook(15, lid_x)] += accum[hook(15, lid_x + 16)];
  barrier(0x01);
  if (lid_x < 8)
    accum[hook(15, lid_x)] += accum[hook(15, lid_x + 8)];
  barrier(0x01);
  if (lid_x < 4)
    accum[hook(15, lid_x)] += accum[hook(15, lid_x + 4)];
  barrier(0x01);
  if (lid_x < 2)
    accum[hook(15, lid_x)] += accum[hook(15, lid_x + 2)];
  barrier(0x01);
  if (lid_x < 1)
    accum[hook(15, lid_x)] += accum[hook(15, lid_x + 1)];
  barrier(0x01);

  float len_sq = accum[hook(15, 0)];
  float len_inv = 1.0f / sqrt(len_sq);

  for (int i = lid_x; i < histlen; i += lsz_x) {
    desc[hook(16, lid_y * histlen + i)] *= len_inv;
  }
  barrier(0x01);
}

kernel void removeDuplicates(global float* x_out, global float* y_out, global unsigned* layer_out, global float* response_out, global float* size_out, global unsigned* counter, global const float* x_in, global const float* y_in, global const unsigned* layer_in, global const float* response_in, global const float* size_in, const unsigned total_feat) {
  const unsigned f = get_global_id(0);

  if (f < total_feat) {
    const float prec_fctr = 1e4f;

    bool cond = (f < total_feat - 1) ? !(round(x_in[hook(6, f)] * prec_fctr) == round(x_in[hook(6, f + 1)] * prec_fctr) && round(y_in[hook(7, f)] * prec_fctr) == round(y_in[hook(7, f + 1)] * prec_fctr) && layer_in[hook(8, f)] == layer_in[hook(8, f + 1)] && round(response_in[hook(9, f)] * prec_fctr) == round(response_in[hook(9, f + 1)] * prec_fctr) && round(size_in[hook(10, f)] * prec_fctr) == round(size_in[hook(10, f + 1)] * prec_fctr)) : true;

    if (cond) {
      unsigned idx = atomic_inc(counter);

      x_out[hook(0, idx)] = x_in[hook(6, f)];
      y_out[hook(1, idx)] = y_in[hook(7, f)];
      layer_out[hook(2, idx)] = layer_in[hook(8, f)];
      response_out[hook(3, idx)] = response_in[hook(9, f)];
      size_out[hook(4, idx)] = size_in[hook(10, f)];
    }
  }
}