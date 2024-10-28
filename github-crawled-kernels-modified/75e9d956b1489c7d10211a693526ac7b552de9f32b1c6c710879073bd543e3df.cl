//{"ang":7,"chnl_stride":3,"data":6,"gsincos":1,"in_out":0,"log2N":4,"log2_n":5,"scale":2}
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

  A = &data[hook(6, mul24((n << 1), i) + j)];
  B = &data[hook(6, mul24((n << 1), i) + n + j)];

  C = &data[hook(6, mul24((n << 1), i) + n - diff)];
  D = &data[hook(6, mul24((n << 1), i) + (n << 1) - diff)];

  float dsin = ang[hook(7, ang_off)];
  float dcos = ang[hook(7, ang_off + 1)];

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

kernel void amdFHTGlbl(global float* in_out, global const float* gsincos,

                       float scale, int chnl_stride, int log2N, int log2_n

) {
  int k = get_global_id(0);
  int lcl_id = get_local_id(0);
  int chnl = get_group_id(1);
  int chnl_off = chnl_stride * chnl;
  int n, n2;

  {
    int log2_n2 = log2N - 1 - log2_n;
    n = (1 << log2_n);
    n2 = (1 << log2_n2);
    int limit = mad24(n2, n / 2, n2);
    FHTIterationGlbl(in_out + chnl_off, gsincos, n, n2, k, limit);
  }
}