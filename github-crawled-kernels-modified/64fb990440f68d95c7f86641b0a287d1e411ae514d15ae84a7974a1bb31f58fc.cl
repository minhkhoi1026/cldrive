//{"p":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 mul_1(float2 a, float2 b) {
  float2 x;
  x.even = (a.even * b.even - a.odd * b.odd);
  x.odd = (a.even * b.odd + a.odd * b.even);
  return x;
}

float4 mul_2(float4 a, float4 b)

{
  float4 x;
  x.even = (a.even * b.even - a.odd * b.odd);
  x.odd = (a.even * b.odd + a.odd * b.even);
  return x;
}

float4 dft2(float4 a) {
  return (float4)(a.lo + a.hi, a.lo - a.hi);
}

float2 exp_alpha_1(float alpha)

{
  float cs, sn;

  cs = native_cos(alpha);
  sn = native_sin(alpha);

  return (float2)(cs, sn);
}

kernel void fft_radix2(global const float2* x, global float2* y, int p)

{
  int i = get_global_id(0);

  int t = get_global_size(0);

  int k = i & (p - 1);

  x += i;

  y += (i << 1) - k;

  float4 u = dft2((float4)(

      x[hook(0, 0)],

      mul_1(exp_alpha_1(-3.14159265358979323846f * (float)k / (float)p), x[hook(0, t)])));

  y[hook(1, 0)] = u.lo;

  y[hook(1, p)] = u.hi;
}