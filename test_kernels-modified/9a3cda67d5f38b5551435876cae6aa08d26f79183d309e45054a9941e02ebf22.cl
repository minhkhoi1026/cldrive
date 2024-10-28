//{"(*x)":5,"i2":6,"p":2,"u2":4,"v1":3,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 doSomeMore(float4 x) {
  char little = clamp(120, 0, 100);
  float deg = degrees(2.0f);
  int m = max(4, 5);
  m = min(4, 5);
  float blend = mix(1.7f, 2.5f, 0.5f);
  float rad = radians(deg);
  int s = sign(-5.0f);
  float4 v1;
  float4 v2;
  float4 c = cross(v1, v2);
  float d = dot(v1, v2);
  float dis = distance(v1, v2);
  float l = length(v1 - v2);
  float4 n = normalize(v1);
  float fd = fast_distance(v1, v2);
  float fl = fast_length(v1 - v2);
  float4 fn = fast_normalize(v1);

  return fn;
}

int doSomeStuff(int i) {
  i = i + 1;
  float f = i;
  float a = acos(f);

  i = ceil(f);
  int fl = floor(f);

  f = cospi(f);
  fl = ceil(f);

  float g = copysign(f, -1.0f);

  for (int x = 0; x < 10; ++x)
    g += x * x - fl;

  return fl * g;
}

kernel void test_kernel(global const float2* x, global float2* y, int p) {
  char little = clamp(120, 0, 100);
  float deg = degrees(2.0f);
  int m = max(4, 5);
  m = min(4, 5);
  float blend = mix(1.7f, 2.5f, 0.5f);
  float rad = radians(deg);
  float mx = max(deg, rad);
  int s = sign(-5.0f);
  float4 v1;
  v1[hook(3, 0)] = 0x1.fffffep127f;
  v1[hook(3, 1)] = (__builtin_huge_valf());
  v1[hook(3, 2)] = (__builtin_inff());
  v1[hook(3, 3)] = __builtin_astype((2147483647), float);
  float4 v2;
  float ex = exp(mx);
  float ex10 = exp10(mx);
  float ex2 = exp2(mx);
  ex = log(ex);
  ex10 = log10(ex10);
  ex2 = log2(ex2);
  float4 c = cross(v1, v2);
  float d = dot(v1, v2);
  float dis = distance(v1, v2);
  float l = length(v1 - v2);
  float4 n = normalize(v1);
  float fd = fast_distance(v1, v2);
  float fl = fast_length(v1 - v2);
  float4 fn = fast_normalize(v1);

  short a = vec_step(v2);
  ushort ad = abs_diff((short)500, a);

  uchar2 u2;
  u2[hook(4, 0)] = (uchar)((*x)[hook(5, 0)]);
  u2[hook(4, 1)] = (uchar)((*x)[hook(5, 1)]);
  uchar lz = clz(u2[hook(4, 0)]);
  uchar2 lz2 = clz(u2);
  int m24 = mad24(s, 42, 154);
  int2 i2;
  i2[hook(6, 0)] = ((*x)[hook(5, 0)]);
  i2[hook(6, 1)] = ((*x)[hook(5, 1)]);
  i2 = mul24(i2, i2);
  i2[hook(6, 1)] = mul24(m, 42);
  fn = mad(fn, fn, fn);
  int mhi = mad_hi(s, 42, 154);
  int msat = mad_sat(s, 42, 154);
  m24 = mul24(s, 42);
  mhi = mul_hi(s, 42);
  int2 rot = rotate(i2, 3);
  uchar2 subs = sub_sat(u2, 42);
  ushort2 upsam = upsample(u2, u2);
  float sqr = sqrt(rad);
  float non = nan((unsigned int)17);
  non = rsqrt(non);

  rot = shuffle(rot, convert_uint2(rot));
  int4 sh = shuffle2(rot, i2, (uint4)(1, 3, 2, 1));

  if (a < ad) {
    for (int i = 0; i < 100; ++i)
      a += i;
    doSomeMore(n);
  }
  a = max((ushort)a, ad);
  s = a == 4 ? 4 : 5;
  *y = s;

  a = a * s;
  s = a / s;
  m = m / 4;
  int k = s * 128;
  s = m % k + non;

  *y = doSomeStuff(s + sh.y);
}