//{"ang":11,"channels_map":4,"chnl_stride":6,"current_bin":9,"data":10,"frame_ln":8,"gbitreverse":2,"gsincos":3,"in":0,"out":1,"que_ln":7,"scaling":5}
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
kernel void amdFHT64FromQ(global const float* in, global float* out, global const short* gbitreverse, global const float* gsincos, global const int* channels_map, float scaling, int chnl_stride, int que_ln, int frame_ln, int current_bin) {
  int lcl_id = get_local_id(0);
  int chnl = channels_map[hook(4, get_group_id(1))];
  int chnl_off = chnl_stride * chnl;
  int bin_off, prev_bin;

  local float data[64];

  bin_off = current_bin * frame_ln;
  for (int i = lcl_id; i < 64 / 2; i += 32) {
    data[hook(10, gbitreverse[ihook(2, i))] = in[hook(0, i + chnl_off + bin_off)];
  }

  prev_bin = (current_bin - 1) < 0 ? que_ln - 1 : (current_bin - 1);
  bin_off = prev_bin * frame_ln;
  for (int i = lcl_id; i < 64 / 2; i += 32) {
    data[hook(10, gbitreverse[6hook(2, 64 / 2 + i))] = in[hook(0, i + chnl_off + bin_off)];
  }

  barrier(0x01);

  int n = 1;
  int n2 = 64 / 2;
  for (int log2_n = 0, log2_n2 = 6 - 1; log2_n < 6; log2_n++, log2_n2--) {
    n = (1 << log2_n);
    n2 = (1 << log2_n2);

    for (int k = lcl_id; k < 64; k += 32) {
      FHTIteration(data, gsincos, n, n2, k);
    }
    barrier(0x01);
  }
  for (int i = lcl_id; i < 64; i += 32) {
    out[hook(1, i + frame_ln * 2 * chnl)] = data[hook(10, i)];
  }
}