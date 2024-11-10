//{"ang":14,"channels_map":4,"chnl_stride":6,"chnl_stride2":12,"current_bin":8,"data":13,"data1":15,"data2":16,"frame_ln":7,"gbitreverse":2,"gsincos":3,"in1":0,"in2":9,"index2":11,"out":1,"out2":10,"scale":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void FHTIterationGlbl(global float* data, const global float* ang, int n, int n2, int k, int limit) {
  global float* A;
  global float* B;
  global float* C;
  global float* D;
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
  int i, j, ang_off;

  i = (int)((float)k / (float)(n / 2 + 1));
  j = k - mul24(i, (n / 2 + 1));

  int diff = (j == 0) ? n : j;

  float flip_sign = (float)((j == 0) ? -1 : 1);

  ang_off = mul24(j, (n2 << 1));

  A = &data[hook(13, mul24((n << 1), i) + j)];
  B = &data[hook(13, mul24((n << 1), i) + n + j)];

  C = &data[hook(13, mul24((n << 1), i) + n - diff)];
  D = &data[hook(13, mul24((n << 1), i) + (n << 1) - diff)];

  float dsin = ang[hook(14, ang_off)];
  float dcos = ang[hook(14, ang_off + 1)];

  a = *A;
  b = *B;
  c = *C;
  d = *D;

  barrier(0x02);

  e = b * dcos + d * dsin;
  f = b * dsin - d * dcos;

  f *= flip_sign;
  if (k < limit) {
    *B = a - e;
    *A = a + e;
    *D = c - f;
    *C = c + f;
  }
  barrier(0x02);
}

void FHTIteration(local float* data, global const float* ang, int n, int n2, int k) {
  float a;
  float b;
  float c;
  float d;
  float e;
  float f;
  int i, j, ang_off;
  i = (int)((float)k / (float)(n / 2 + 1));
  j = k - mul24(i, (n / 2 + 1));

  int diff = (j == 0) ? n : j;

  float flip_sign = (float)((j == 0) ? -1 : 1);

  ang_off = mul24(j, (n2 << 1));

  int a_off = mad24((n << 1), i, j);
  a = data[hook(13, a_off)];
  b = data[hook(13, a_off + n)];

  int c_off = mad24((n << 1), i, n - diff);
  c = data[hook(13, c_off)];
  d = data[hook(13, c_off + n)];

  float dsin = ang[hook(14, ang_off)];
  float dcos = ang[hook(14, ang_off + 1)];

  e = b * dcos + d * dsin;
  f = b * dsin - d * dcos;

  f *= flip_sign;

  if (k < mad24(n2, n / 2, n2)) {
    data[hook(13, a_off + n)] = a - e;
    data[hook(13, a_off)] = a + e;
    data[hook(13, c_off + n)] = c - f;
    data[hook(13, c_off)] = c + f;
  }
}
kernel void amdFHT128FromSXFade(global const float* in1, global float* out, global const short* gbitreverse, global const float* gsincos, global const int* channels_map, float scale, int chnl_stride, int frame_ln, int current_bin, global const float* in2, global const float* out2, int index2, int chnl_stride2) {
  int lcl_id = get_local_id(0);
  int chnl = channels_map[hook(4, get_group_id(1))];
  int chnl_off = chnl_stride * chnl;

  local float data1[128];
  local float data2[128];
  for (int i = lcl_id; i < 128; i += 64) {
    data1[hook(15, gbitreverse[ihook(2, i))] = in1[hook(0, i + chnl_off)];
    data2[hook(16, gbitreverse[ihook(2, i))] = in2[hook(9, i + chnl_off)];
  }

  barrier(0x01);

  int n = 1;
  int n2 = 128 / 2;
  for (int log2_n = 0, log2_n2 = 7 - 1; log2_n < 7; log2_n++, log2_n2--) {
    n = (1 << log2_n);
    n2 = (1 << log2_n2);

    for (int k = lcl_id; k < 128; k += 64) {
      FHTIteration(data1, gsincos, n, n2, k);
      FHTIteration(data2, gsincos, n, n2, k);
    }
    barrier(0x01);
  }
  int out2_off = mul24(chnl_stride2, chnl) + mul24(index2, 128 / 2);
  for (int i = lcl_id; i < 128 / 2; i += 64) {
    float fadeInCoeff = (float)i / (float)(128 / 2 - 1);
    float fadeOutCoeff = 1.0 - fadeInCoeff;
    out[hook(1, i + (frame_ln / 2) * chnl)] = ((fadeInCoeff * data1[hook(15, i)] + fadeOutCoeff * data2[hook(16, i)]) * scale * (float)0.5) + out2[hook(10, out2_off + i)];
  }
}