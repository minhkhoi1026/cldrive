//{"ang":11,"channels_map":4,"chnl_stride":6,"current_bin":8,"data":10,"frame_ln":7,"gbitreverse":2,"gsincos":3,"in":0,"out":1,"scale":5,"xfade_span":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
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
  a = data[hook(10, a_off)];
  b = data[hook(10, a_off + n)];

  int c_off = mad24((n << 1), i, n - diff);
  c = data[hook(10, c_off)];
  d = data[hook(10, c_off + n)];

  float dsin = ang[hook(11, ang_off)];
  float dcos = ang[hook(11, ang_off + 1)];

  e = b * dcos + d * dsin;
  f = b * dsin - d * dcos;

  f *= flip_sign;

  if (k < mad24(n2, n / 2, n2)) {
    data[hook(10, a_off + n)] = a - e;
    data[hook(10, a_off)] = a + e;
    data[hook(10, c_off + n)] = c - f;
    data[hook(10, c_off)] = c + f;
  }
}
kernel void amdFHT512FromSXFade(global const float* in, global float* out, global const short* gbitreverse, global const float* gsincos, global const int* channels_map, float scale, int chnl_stride, int frame_ln, int current_bin, int xfade_span) {
  int lcl_id = get_local_id(0);
  int chnl = channels_map[hook(4, get_group_id(1))];
  int chnl_off = chnl_stride * chnl;

  local float data[512];
  for (int i = lcl_id; i < 512; i += 256) {
    data[hook(10, gbitreverse[ihook(2, i))] = in[hook(0, i + chnl_off)];
  }

  barrier(0x01);

  int n = 1;
  int n2 = 512 / 2;
  for (int log2_n = 0, log2_n2 = 9 - 1; log2_n < 9; log2_n++, log2_n2--) {
    n = (1 << log2_n);
    n2 = (1 << log2_n2);

    for (int k = lcl_id; k < 512; k += 256) {
      FHTIteration(data, gsincos, n, n2, k);
    }
    barrier(0x01);
  }

  for (int i = lcl_id; i < 512 / 2; i += 256) {
    float fadeInCoeff = (float)(i) / (float)(xfade_span - 1);
    fadeInCoeff = (fadeInCoeff > 1.0) ? 1.0 : fadeInCoeff;
    float fadeOutCoeff = 1.0 - fadeInCoeff;
    float tempOut = (data[hook(10, i)] * scale * (float)0.5);
    out[hook(1, i + (frame_ln / 2) * chnl)] = tempOut * fadeInCoeff + out[hook(1, i + (frame_ln / 2) * chnl)] * fadeOutCoeff;
  }
}