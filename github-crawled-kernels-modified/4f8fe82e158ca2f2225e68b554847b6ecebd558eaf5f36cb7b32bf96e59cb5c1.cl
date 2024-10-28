//{"ang":9,"channels_map":4,"chnl_stride":7,"data":8,"frame_ln":6,"gbitreverse":2,"gsincos":3,"in":0,"out":1,"scaling":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void FHTIteration_gcs(local float* data, const global float* ang, int n, int n2, int k) {
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
  a = data[hook(8, a_off)];
  b = data[hook(8, a_off + n)];

  int c_off = mad24((n << 1), i, n - diff);
  c = data[hook(8, c_off)];
  d = data[hook(8, c_off + n)];

  float dsin = ang[hook(9, ang_off)];
  float dcos = ang[hook(9, ang_off + 1)];

  e = b * dcos + d * dsin;
  f = b * dsin - d * dcos;

  f *= flip_sign;

  if (k < mad24(n2, n / 2, n2)) {
    data[hook(8, a_off + n)] = a - e;
    data[hook(8, a_off)] = a + e;
    data[hook(8, c_off + n)] = c - f;
    data[hook(8, c_off)] = c + f;
  }
}
void FHTransformLoop(local float* data, global const float* gsincos) {
  int lcl_id = get_local_id(0);
  int n = 1;
  int n2 = 8192 / 2;
  for (int log2_n = 0, log2_n2 = 13 - 1; log2_n < 13; log2_n++, log2_n2--) {
    n = (1 << log2_n);
    n2 = (1 << log2_n2);

    for (int k = lcl_id; k < 8192; k += 256) {
      FHTIteration_gcs(data, gsincos, n, n2, k);
    }
    barrier(0x01);
  }
}

void FHTransformLoop2(local float* data, global const float* gsincos) {
}

kernel void amdFHT16384(global const float* in, global float* out, global const short* gbitreverse, global const float* gsincos, global const int* channels_map, float scaling, int frame_ln, int chnl_stride) {
}