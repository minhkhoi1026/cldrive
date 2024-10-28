//{"buf":4,"input":0,"output":1,"r":3,"win":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 cmul_1(float2 a, float2 b) {
  float2 x;
  x.even = (a.even * b.even - a.odd * b.odd);
  x.odd = (a.even * b.odd + a.odd * b.even);
  return x;
}

float4 cmul_2(float4 a, float4 b) {
  float4 x;
  x.even = (a.even * b.even - a.odd * b.odd);
  x.odd = (a.even * b.odd + a.odd * b.even);
  return x;
}

float2 twiddle(float2 a, int k, float alpha) {
  float cv, sv;

  sv = native_sin(k * alpha);
  cv = native_cos(k * alpha);
  return cmul_1(a, (float2)(cv, sv));
}

constant float SQRT_1_2 = 0.707106781188f;

float2 mul_p1q2(float2 a) {
  return (float2)(a.y, -a.x);
}

float2 mul_p1q4(float2 a) {
  return (float2)(SQRT_1_2) * (float2)(a.x + a.y, -a.x + a.y);
}

float2 mul_p3q4(float2 a) {
  return (float2)(SQRT_1_2) * (float2)(-a.x + a.y, -a.x - a.y);
}

__attribute__((always_inline)) void dft2(float2* r0, float2* r1) {
  float2 tmp;

  tmp = *r0 - *r1;
  *r0 = *r0 + *r1;
  *r1 = tmp;
}

__attribute__((always_inline)) void dft4(float2* r0, float2* r1, float2* r2, float2* r3) {
  dft2(r0, r2);
  dft2(r1, r3);

  *r2 = (*r2);
  *r3 = mul_p1q2(*r3);

  dft2(r0, r1);
  dft2(r2, r3);
}

__attribute__((always_inline)) void dft8(float2* r0, float2* r1, float2* r2, float2* r3, float2* r4, float2* r5, float2* r6, float2* r7) {
  dft2(r0, r4);
  dft2(r1, r5);
  dft2(r2, r6);
  dft2(r3, r7);

  *r4 = (*r4);
  *r5 = mul_p1q4(*r5);
  *r6 = mul_p1q2(*r6);
  *r7 = mul_p3q4(*r7);

  dft2(r0, r2);
  dft2(r1, r3);
  dft2(r4, r6);
  dft2(r5, r7);

  *r2 = (*r2);
  *r3 = mul_p1q2(*r3);
  *r6 = (*r6);
  *r7 = mul_p1q2(*r7);

  dft2(r0, r1);
  dft2(r2, r3);
  dft2(r4, r5);
  dft2(r6, r7);
}
__attribute__((always_inline)) void fft_radix2_exec(float2* r) {
  dft2(&r[hook(3, 0)], &r[hook(3, 1)]);
}

__attribute__((always_inline)) void fft_radix2_twiddle(float2* r, int k, int p) {
  float alpha = -(3.141592653589f) * (float)k / (float)(p);

  r[hook(3, 1)] = twiddle(r[hook(3, 1)], 1, alpha);
}

__attribute__((always_inline)) void fft_radix2_load(local float2* buf, float2* r, int i, int t) {
  buf += i;

  r[hook(3, 0)] = buf[hook(4, 0)];
  r[hook(3, 1)] = buf[hook(4, t)];
}

__attribute__((always_inline)) void fft_radix2_store(local float2* buf, float2* r, int i, int k, int p) {
  int j = ((i - k) << 1) + k;

  buf += j;

  buf[hook(4, 0)] = r[hook(3, 0)];
  buf[hook(4, p)] = r[hook(3, 1)];
}

__attribute__((always_inline)) void fft_radix2(local float2* buf, float2* r, int p, int i, int t, int twiddle) {
  int k = i & (p - 1);

  fft_radix2_load(buf, r, i, t);

  if (twiddle)
    fft_radix2_twiddle(r, k, p);

  fft_radix2_exec(r);

  barrier(0x01);

  fft_radix2_store(buf, r, i, k, p);

  barrier(0x01);
}

__attribute__((always_inline)) void fft_radix4_exec(float2* r) {
  dft4(&r[hook(3, 0)], &r[hook(3, 1)], &r[hook(3, 2)], &r[hook(3, 3)]);
}

__attribute__((always_inline)) void fft_radix4_twiddle(float2* r, int k, int p) {
  float alpha = -(3.141592653589f) * (float)k / (float)(2 * p);

  r[hook(3, 1)] = twiddle(r[hook(3, 1)], 1, alpha);
  r[hook(3, 2)] = twiddle(r[hook(3, 2)], 2, alpha);
  r[hook(3, 3)] = twiddle(r[hook(3, 3)], 3, alpha);
}

__attribute__((always_inline)) void fft_radix4_load(local float2* buf, float2* r, int i, int t) {
  buf += i;

  r[hook(3, 0)] = buf[hook(4, 0)];
  r[hook(3, 1)] = buf[hook(4, t)];
  r[hook(3, 2)] = buf[hook(4, 2 * t)];
  r[hook(3, 3)] = buf[hook(4, 3 * t)];
}

__attribute__((always_inline)) void fft_radix4_store(local float2* buf, float2* r, int i, int k, int p) {
  int j = ((i - k) << 2) + k;

  buf += j;

  buf[hook(4, 0)] = r[hook(3, 0)];
  buf[hook(4, p)] = r[hook(3, 2)];
  buf[hook(4, 2 * p)] = r[hook(3, 1)];
  buf[hook(4, 3 * p)] = r[hook(3, 3)];
}

__attribute__((always_inline)) void fft_radix4(local float2* buf, float2* r, int p, int i, int t, int twiddle) {
  int k = i & (p - 1);

  fft_radix4_load(buf, r, i, t);

  if (twiddle)
    fft_radix4_twiddle(r, k, p);

  fft_radix4_exec(r);

  barrier(0x01);

  fft_radix4_store(buf, r, i, k, p);

  barrier(0x01);
}

__attribute__((always_inline)) void fft_radix8_exec(float2* r) {
  dft8(&r[hook(3, 0)], &r[hook(3, 1)], &r[hook(3, 2)], &r[hook(3, 3)], &r[hook(3, 4)], &r[hook(3, 5)], &r[hook(3, 6)], &r[hook(3, 7)]);
}

__attribute__((always_inline)) void fft_radix8_twiddle(float2* r, int k, int p) {
  float alpha = -(3.141592653589f) * (float)k / (float)(4 * p);

  r[hook(3, 1)] = twiddle(r[hook(3, 1)], 1, alpha);
  r[hook(3, 2)] = twiddle(r[hook(3, 2)], 2, alpha);
  r[hook(3, 3)] = twiddle(r[hook(3, 3)], 3, alpha);
  r[hook(3, 4)] = twiddle(r[hook(3, 4)], 4, alpha);
  r[hook(3, 5)] = twiddle(r[hook(3, 5)], 5, alpha);
  r[hook(3, 6)] = twiddle(r[hook(3, 6)], 6, alpha);
  r[hook(3, 7)] = twiddle(r[hook(3, 7)], 7, alpha);
}

__attribute__((always_inline)) void fft_radix8_load(local float2* buf, float2* r, int i, int t) {
  buf += i;

  r[hook(3, 0)] = buf[hook(4, 0)];
  r[hook(3, 1)] = buf[hook(4, t)];
  r[hook(3, 2)] = buf[hook(4, 2 * t)];
  r[hook(3, 3)] = buf[hook(4, 3 * t)];
  r[hook(3, 4)] = buf[hook(4, 4 * t)];
  r[hook(3, 5)] = buf[hook(4, 5 * t)];
  r[hook(3, 6)] = buf[hook(4, 6 * t)];
  r[hook(3, 7)] = buf[hook(4, 7 * t)];
}

__attribute__((always_inline)) void fft_radix8_store(local float2* buf, float2* r, int i, int k, int p) {
  int j = ((i - k) << 3) + k;

  buf += j;

  buf[hook(4, 0)] = r[hook(3, 0)];
  buf[hook(4, p)] = r[hook(3, 4)];
  buf[hook(4, 2 * p)] = r[hook(3, 2)];
  buf[hook(4, 3 * p)] = r[hook(3, 6)];
  buf[hook(4, 4 * p)] = r[hook(3, 1)];
  buf[hook(4, 5 * p)] = r[hook(3, 5)];
  buf[hook(4, 6 * p)] = r[hook(3, 3)];
  buf[hook(4, 7 * p)] = r[hook(3, 7)];
}

__attribute__((always_inline)) void fft_radix8(local float2* buf, float2* r, int p, int i, int t, int twiddle) {
  int k = i & (p - 1);

  fft_radix8_load(buf, r, i, t);

  if (twiddle)
    fft_radix8_twiddle(r, k, p);

  fft_radix8_exec(r);

  barrier(0x01);

  fft_radix8_store(buf, r, i, k, p);

  barrier(0x01);
}

kernel void fft1D_1024(global const float2* input, global float2* output, constant const float* win) {
  local float2 buf[1024];

  float2 r[8];
  int lid = get_local_id(0);
  int i;

  input += 1024 * get_global_id(1);
  output += 1024 * get_global_id(1);

  for (i = lid; i < 1024; i += (1024 / 8))
    buf[hook(4, i)] = input[hook(0, i)] * win[hook(2, i)];

  fft_radix8(buf, r, 1, lid, (1024 / 8), 0);

  fft_radix8(buf, r, 8, lid, (1024 / 8), 1);

  fft_radix8(buf, r, 64, lid, (1024 / 8), 1);

  {
    const int p = 512;
    const int i = lid << 2;
    const int t = (1024 / 8) << 2;
    const int k = i;

    fft_radix2_load(buf, r + 0, i + 0, t);
    fft_radix2_load(buf, r + 2, i + 1, t);
    fft_radix2_load(buf, r + 4, i + 2, t);
    fft_radix2_load(buf, r + 6, i + 3, t);

    fft_radix2_twiddle(r + 0, k + 0, p);
    fft_radix2_twiddle(r + 2, k + 1, p);
    fft_radix2_twiddle(r + 4, k + 2, p);
    fft_radix2_twiddle(r + 6, k + 3, p);

    fft_radix2_exec(r + 0);
    fft_radix2_exec(r + 2);
    fft_radix2_exec(r + 4);
    fft_radix2_exec(r + 6);

    barrier(0x01);

    fft_radix2_store(buf, r + 0, i + 0, k + 0, p);
    fft_radix2_store(buf, r + 2, i + 1, k + 1, p);
    fft_radix2_store(buf, r + 4, i + 2, k + 2, p);
    fft_radix2_store(buf, r + 6, i + 3, k + 3, p);

    barrier(0x01);
  }

  for (i = 0; i < 8; i++)
    output[hook(1, i * (1024 / 8) + lid)] = buf[hook(4, i * (1024 / 8) + lid)];
}