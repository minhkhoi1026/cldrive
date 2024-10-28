//{"gimag":1,"gp":2,"greal":0,"lp":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((always_inline)) float k_sincos(int i, float* cretp) {
  if (i > 512)
    i -= 1024;

  float x = i * -0x1.921fb6p-8F;
  *cretp = native_cos(x);
  return native_sin(x);
}

__attribute__((always_inline)) float4 k_sincos4(int4 i, float4* cretp) {
  i -= (i > 512) & 1024;
  float4 x = convert_float4(i) * -0x1.921fb6p-8F;
  *cretp = native_cos(x);
  return native_sin(x);
}
__attribute__((always_inline)) void kfft_pass1(unsigned int me, const global float* gr, const global float* gi, local float* lds) {
  const global float4* gp;
  local float* lp;

  gp = (const global float4*)(gr + (me << 2));
  float4 zr0 = gp[hook(2, 0 * 64)];
  float4 zr1 = gp[hook(2, 1 * 64)];
  float4 zr2 = gp[hook(2, 2 * 64)];
  float4 zr3 = gp[hook(2, 3 * 64)];

  gp = (const global float4*)(gi + (me << 2));
  float4 zi0 = gp[hook(2, 0 * 64)];
  float4 zi1 = gp[hook(2, 1 * 64)];
  float4 zi2 = gp[hook(2, 2 * 64)];
  float4 zi3 = gp[hook(2, 3 * 64)];

  do {
    float4 ar0 = zr0 + zr2;
    float4 ar2 = zr1 + zr3;
    float4 br0 = ar0 + ar2;
    float4 br1 = zr0 - zr2;
    float4 br2 = ar0 - ar2;
    float4 br3 = zr1 - zr3;
    float4 ai0 = zi0 + zi2;
    float4 ai2 = zi1 + zi3;
    float4 bi0 = ai0 + ai2;
    float4 bi1 = zi0 - zi2;
    float4 bi2 = ai0 - ai2;
    float4 bi3 = zi1 - zi3;
    zr0 = br0;
    zi0 = bi0;
    zr1 = br1 + bi3;
    zi1 = bi1 - br3;
    zr3 = br1 - bi3;
    zi3 = br3 + bi1;
    zr2 = br2;
    zi2 = bi2;
  } while (0);

  int4 tbase = (int)(me << 2) + (int4)(0, 1, 2, 3);
  do {
    float4 c1;
    float4 s1 = k_sincos4(tbase * 1, &c1);
    do {
      float4 __r = c1 * zr1 - s1 * zi1;
      zi1 = c1 * zi1 + s1 * zr1;
      zr1 = __r;
    } while (0);
    float4 c2;
    float4 s2 = k_sincos4(tbase * 2, &c2);
    do {
      float4 __r = c2 * zr2 - s2 * zi2;
      zi2 = c2 * zi2 + s2 * zr2;
      zr2 = __r;
    } while (0);
    float4 c3;
    float4 s3 = k_sincos4(tbase * 3, &c3);
    do {
      float4 __r = c3 * zr3 - s3 * zi3;
      zi3 = c3 * zi3 + s3 * zr3;
      zr3 = __r;
    } while (0);
  } while (0);

  lp = lds + ((me << 2) + (me >> 3));

  lp[hook(3, 0)] = zr0.x;
  lp[hook(3, 1)] = zr0.y;
  lp[hook(3, 2)] = zr0.z;
  lp[hook(3, 3)] = zr0.w;
  lp += 66 * 4;

  lp[hook(3, 0)] = zr1.x;
  lp[hook(3, 1)] = zr1.y;
  lp[hook(3, 2)] = zr1.z;
  lp[hook(3, 3)] = zr1.w;
  lp += 66 * 4;

  lp[hook(3, 0)] = zr2.x;
  lp[hook(3, 1)] = zr2.y;
  lp[hook(3, 2)] = zr2.z;
  lp[hook(3, 3)] = zr2.w;
  lp += 66 * 4;

  lp[hook(3, 0)] = zr3.x;
  lp[hook(3, 1)] = zr3.y;
  lp[hook(3, 2)] = zr3.z;
  lp[hook(3, 3)] = zr3.w;
  lp += 66 * 4;

  lp[hook(3, 0)] = zi0.x;
  lp[hook(3, 1)] = zi0.y;
  lp[hook(3, 2)] = zi0.z;
  lp[hook(3, 3)] = zi0.w;
  lp += 66 * 4;

  lp[hook(3, 0)] = zi1.x;
  lp[hook(3, 1)] = zi1.y;
  lp[hook(3, 2)] = zi1.z;
  lp[hook(3, 3)] = zi1.w;
  lp += 66 * 4;

  lp[hook(3, 0)] = zi2.x;
  lp[hook(3, 1)] = zi2.y;
  lp[hook(3, 2)] = zi2.z;
  lp[hook(3, 3)] = zi2.w;
  lp += 66 * 4;

  lp[hook(3, 0)] = zi3.x;
  lp[hook(3, 1)] = zi3.y;
  lp[hook(3, 2)] = zi3.z;
  lp[hook(3, 3)] = zi3.w;

  barrier(0x01);
}

__attribute__((always_inline)) void kfft_pass2(unsigned int me, local float* lds) {
  local float* lp;

  lp = lds + (me + (me >> 5));

  float4 zr0, zr1, zr2, zr3;

  zr0.x = lp[hook(3, 0 * 66)];
  zr1.x = lp[hook(3, 1 * 66)];
  zr2.x = lp[hook(3, 2 * 66)];
  zr3.x = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zr0.y = lp[hook(3, 0 * 66)];
  zr1.y = lp[hook(3, 1 * 66)];
  zr2.y = lp[hook(3, 2 * 66)];
  zr3.y = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zr0.z = lp[hook(3, 0 * 66)];
  zr1.z = lp[hook(3, 1 * 66)];
  zr2.z = lp[hook(3, 2 * 66)];
  zr3.z = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zr0.w = lp[hook(3, 0 * 66)];
  zr1.w = lp[hook(3, 1 * 66)];
  zr2.w = lp[hook(3, 2 * 66)];
  zr3.w = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  float4 zi0, zi1, zi2, zi3;

  zi0.x = lp[hook(3, 0 * 66)];
  zi1.x = lp[hook(3, 1 * 66)];
  zi2.x = lp[hook(3, 2 * 66)];
  zi3.x = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zi0.y = lp[hook(3, 0 * 66)];
  zi1.y = lp[hook(3, 1 * 66)];
  zi2.y = lp[hook(3, 2 * 66)];
  zi3.y = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zi0.z = lp[hook(3, 0 * 66)];
  zi1.z = lp[hook(3, 1 * 66)];
  zi2.z = lp[hook(3, 2 * 66)];
  zi3.z = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zi0.w = lp[hook(3, 0 * 66)];
  zi1.w = lp[hook(3, 1 * 66)];
  zi2.w = lp[hook(3, 2 * 66)];
  zi3.w = lp[hook(3, 3 * 66)];

  do {
    float4 ar0 = zr0 + zr2;
    float4 ar2 = zr1 + zr3;
    float4 br0 = ar0 + ar2;
    float4 br1 = zr0 - zr2;
    float4 br2 = ar0 - ar2;
    float4 br3 = zr1 - zr3;
    float4 ai0 = zi0 + zi2;
    float4 ai2 = zi1 + zi3;
    float4 bi0 = ai0 + ai2;
    float4 bi1 = zi0 - zi2;
    float4 bi2 = ai0 - ai2;
    float4 bi3 = zi1 - zi3;
    zr0 = br0;
    zi0 = bi0;
    zr1 = br1 + bi3;
    zi1 = bi1 - br3;
    zr3 = br1 - bi3;
    zi3 = br3 + bi1;
    zr2 = br2;
    zi2 = bi2;
  } while (0);

  int tbase = (int)(me << 2);
  do {
    float c1;
    float s1 = k_sincos(tbase * 1, &c1);
    do {
      float4 __r = c1 * zr1 - s1 * zi1;
      zi1 = c1 * zi1 + s1 * zr1;
      zr1 = __r;
    } while (0);
    float c2;
    float s2 = k_sincos(tbase * 2, &c2);
    do {
      float4 __r = c2 * zr2 - s2 * zi2;
      zi2 = c2 * zi2 + s2 * zr2;
      zr2 = __r;
    } while (0);
    float c3;
    float s3 = k_sincos(tbase * 3, &c3);
    do {
      float4 __r = c3 * zr3 - s3 * zi3;
      zi3 = c3 * zi3 + s3 * zr3;
      zr3 = __r;
    } while (0);
  } while (0);

  barrier(0x01);

  lp = lds + ((me << 2) + (me >> 3));

  lp[hook(3, 0)] = zr0.x;
  lp[hook(3, 1)] = zr1.x;
  lp[hook(3, 2)] = zr2.x;
  lp[hook(3, 3)] = zr3.x;
  lp += 66 * 4;

  lp[hook(3, 0)] = zr0.y;
  lp[hook(3, 1)] = zr1.y;
  lp[hook(3, 2)] = zr2.y;
  lp[hook(3, 3)] = zr3.y;
  lp += 66 * 4;

  lp[hook(3, 0)] = zr0.z;
  lp[hook(3, 1)] = zr1.z;
  lp[hook(3, 2)] = zr2.z;
  lp[hook(3, 3)] = zr3.z;
  lp += 66 * 4;

  lp[hook(3, 0)] = zr0.w;
  lp[hook(3, 1)] = zr1.w;
  lp[hook(3, 2)] = zr2.w;
  lp[hook(3, 3)] = zr3.w;
  lp += 66 * 4;

  lp[hook(3, 0)] = zi0.x;
  lp[hook(3, 1)] = zi1.x;
  lp[hook(3, 2)] = zi2.x;
  lp[hook(3, 3)] = zi3.x;
  lp += 66 * 4;

  lp[hook(3, 0)] = zi0.y;
  lp[hook(3, 1)] = zi1.y;
  lp[hook(3, 2)] = zi2.y;
  lp[hook(3, 3)] = zi3.y;
  lp += 66 * 4;

  lp[hook(3, 0)] = zi0.z;
  lp[hook(3, 1)] = zi1.z;
  lp[hook(3, 2)] = zi2.z;
  lp[hook(3, 3)] = zi3.z;
  lp += 66 * 4;

  lp[hook(3, 0)] = zi0.w;
  lp[hook(3, 1)] = zi1.w;
  lp[hook(3, 2)] = zi2.w;
  lp[hook(3, 3)] = zi3.w;

  barrier(0x01);
}

__attribute__((always_inline)) void kfft_pass3(unsigned int me, local float* lds) {
  local float* lp;

  lp = lds + (me + (me >> 5));

  float4 zr0, zr1, zr2, zr3;

  zr0.x = lp[hook(3, 0 * 66)];
  zr1.x = lp[hook(3, 1 * 66)];
  zr2.x = lp[hook(3, 2 * 66)];
  zr3.x = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zr0.y = lp[hook(3, 0 * 66)];
  zr1.y = lp[hook(3, 1 * 66)];
  zr2.y = lp[hook(3, 2 * 66)];
  zr3.y = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zr0.z = lp[hook(3, 0 * 66)];
  zr1.z = lp[hook(3, 1 * 66)];
  zr2.z = lp[hook(3, 2 * 66)];
  zr3.z = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zr0.w = lp[hook(3, 0 * 66)];
  zr1.w = lp[hook(3, 1 * 66)];
  zr2.w = lp[hook(3, 2 * 66)];
  zr3.w = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  float4 zi0, zi1, zi2, zi3;

  zi0.x = lp[hook(3, 0 * 66)];
  zi1.x = lp[hook(3, 1 * 66)];
  zi2.x = lp[hook(3, 2 * 66)];
  zi3.x = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zi0.y = lp[hook(3, 0 * 66)];
  zi1.y = lp[hook(3, 1 * 66)];
  zi2.y = lp[hook(3, 2 * 66)];
  zi3.y = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zi0.z = lp[hook(3, 0 * 66)];
  zi1.z = lp[hook(3, 1 * 66)];
  zi2.z = lp[hook(3, 2 * 66)];
  zi3.z = lp[hook(3, 3 * 66)];
  lp += 66 * 4;

  zi0.w = lp[hook(3, 0 * 66)];
  zi1.w = lp[hook(3, 1 * 66)];
  zi2.w = lp[hook(3, 2 * 66)];
  zi3.w = lp[hook(3, 3 * 66)];

  do {
    float4 ar0 = zr0 + zr2;
    float4 ar2 = zr1 + zr3;
    float4 br0 = ar0 + ar2;
    float4 br1 = zr0 - zr2;
    float4 br2 = ar0 - ar2;
    float4 br3 = zr1 - zr3;
    float4 ai0 = zi0 + zi2;
    float4 ai2 = zi1 + zi3;
    float4 bi0 = ai0 + ai2;
    float4 bi1 = zi0 - zi2;
    float4 bi2 = ai0 - ai2;
    float4 bi3 = zi1 - zi3;
    zr0 = br0;
    zi0 = bi0;
    zr1 = br1 + bi3;
    zi1 = bi1 - br3;
    zr3 = br1 - bi3;
    zi3 = br3 + bi1;
    zr2 = br2;
    zi2 = bi2;
  } while (0);

  int tbase = (int)((me >> 2) << 4);
  do {
    float c1;
    float s1 = k_sincos(tbase * 1, &c1);
    do {
      float4 __r = c1 * zr1 - s1 * zi1;
      zi1 = c1 * zi1 + s1 * zr1;
      zr1 = __r;
    } while (0);
    float c2;
    float s2 = k_sincos(tbase * 2, &c2);
    do {
      float4 __r = c2 * zr2 - s2 * zi2;
      zi2 = c2 * zi2 + s2 * zr2;
      zr2 = __r;
    } while (0);
    float c3;
    float s3 = k_sincos(tbase * 3, &c3);
    do {
      float4 __r = c3 * zr3 - s3 * zi3;
      zi3 = c3 * zi3 + s3 * zr3;
      zr3 = __r;
    } while (0);
  } while (0);

  barrier(0x01);

  lp = lds + me;

  lp[hook(3, 0 * 66)] = zr0.x;
  lp[hook(3, 1 * 66)] = zr0.y;
  lp[hook(3, 2 * 66)] = zr0.z;
  lp[hook(3, 3 * 66)] = zr0.w;
  lp += 66 * 4;

  lp[hook(3, 0 * 66)] = zr1.x;
  lp[hook(3, 1 * 66)] = zr1.y;
  lp[hook(3, 2 * 66)] = zr1.z;
  lp[hook(3, 3 * 66)] = zr1.w;
  lp += 66 * 4;

  lp[hook(3, 0 * 66)] = zr2.x;
  lp[hook(3, 1 * 66)] = zr2.y;
  lp[hook(3, 2 * 66)] = zr2.z;
  lp[hook(3, 3 * 66)] = zr2.w;
  lp += 66 * 4;

  lp[hook(3, 0 * 66)] = zr3.x;
  lp[hook(3, 1 * 66)] = zr3.y;
  lp[hook(3, 2 * 66)] = zr3.z;
  lp[hook(3, 3 * 66)] = zr3.w;
  lp += 66 * 4;

  lp[hook(3, 0 * 66)] = zi0.x;
  lp[hook(3, 1 * 66)] = zi0.y;
  lp[hook(3, 2 * 66)] = zi0.z;
  lp[hook(3, 3 * 66)] = zi0.w;
  lp += 66 * 4;

  lp[hook(3, 0 * 66)] = zi1.x;
  lp[hook(3, 1 * 66)] = zi1.y;
  lp[hook(3, 2 * 66)] = zi1.z;
  lp[hook(3, 3 * 66)] = zi1.w;
  lp += 66 * 4;

  lp[hook(3, 0 * 66)] = zi2.x;
  lp[hook(3, 1 * 66)] = zi2.y;
  lp[hook(3, 2 * 66)] = zi2.z;
  lp[hook(3, 3 * 66)] = zi2.w;
  lp += 66 * 4;

  lp[hook(3, 0 * 66)] = zi3.x;
  lp[hook(3, 1 * 66)] = zi3.y;
  lp[hook(3, 2 * 66)] = zi3.z;
  lp[hook(3, 3 * 66)] = zi3.w;

  barrier(0x01);
}

__attribute__((always_inline)) void kfft_pass4(unsigned int me, local float* lds) {
  local float* lp;

  lp = lds + ((me & 0x3) + ((me >> 2) & 0x3) * (66 * 4) + ((me >> 4) << 2));

  float4 zr0, zr1, zr2, zr3;

  zr0.x = lp[hook(3, 0 * 66)];
  zr0.y = lp[hook(3, 1 * 66)];
  zr0.z = lp[hook(3, 2 * 66)];
  zr0.w = lp[hook(3, 3 * 66)];
  lp += 16;

  zr1.x = lp[hook(3, 0 * 66)];
  zr1.y = lp[hook(3, 1 * 66)];
  zr1.z = lp[hook(3, 2 * 66)];
  zr1.w = lp[hook(3, 3 * 66)];
  lp += 16;

  zr2.x = lp[hook(3, 0 * 66)];
  zr2.y = lp[hook(3, 1 * 66)];
  zr2.z = lp[hook(3, 2 * 66)];
  zr2.w = lp[hook(3, 3 * 66)];
  lp += 16;

  zr3.x = lp[hook(3, 0 * 66)];
  zr3.y = lp[hook(3, 1 * 66)];
  zr3.z = lp[hook(3, 2 * 66)];
  zr3.w = lp[hook(3, 3 * 66)];
  lp += 66 * 4 * 4 - 3 * 16;

  float4 zi0, zi1, zi2, zi3;

  zi0.x = lp[hook(3, 0 * 66)];
  zi0.y = lp[hook(3, 1 * 66)];
  zi0.z = lp[hook(3, 2 * 66)];
  zi0.w = lp[hook(3, 3 * 66)];
  lp += 16;

  zi1.x = lp[hook(3, 0 * 66)];
  zi1.y = lp[hook(3, 1 * 66)];
  zi1.z = lp[hook(3, 2 * 66)];
  zi1.w = lp[hook(3, 3 * 66)];
  lp += 16;

  zi2.x = lp[hook(3, 0 * 66)];
  zi2.y = lp[hook(3, 1 * 66)];
  zi2.z = lp[hook(3, 2 * 66)];
  zi2.w = lp[hook(3, 3 * 66)];
  lp += 16;

  zi3.x = lp[hook(3, 0 * 66)];
  zi3.y = lp[hook(3, 1 * 66)];
  zi3.z = lp[hook(3, 2 * 66)];
  zi3.w = lp[hook(3, 3 * 66)];

  do {
    float4 ar0 = zr0 + zr2;
    float4 ar2 = zr1 + zr3;
    float4 br0 = ar0 + ar2;
    float4 br1 = zr0 - zr2;
    float4 br2 = ar0 - ar2;
    float4 br3 = zr1 - zr3;
    float4 ai0 = zi0 + zi2;
    float4 ai2 = zi1 + zi3;
    float4 bi0 = ai0 + ai2;
    float4 bi1 = zi0 - zi2;
    float4 bi2 = ai0 - ai2;
    float4 bi3 = zi1 - zi3;
    zr0 = br0;
    zi0 = bi0;
    zr1 = br1 + bi3;
    zi1 = bi1 - br3;
    zr3 = br1 - bi3;
    zi3 = br3 + bi1;
    zr2 = br2;
    zi2 = bi2;
  } while (0);

  int tbase = (int)((me >> 4) << 6);
  do {
    float c1;
    float s1 = k_sincos(tbase * 1, &c1);
    do {
      float4 __r = c1 * zr1 - s1 * zi1;
      zi1 = c1 * zi1 + s1 * zr1;
      zr1 = __r;
    } while (0);
    float c2;
    float s2 = k_sincos(tbase * 2, &c2);
    do {
      float4 __r = c2 * zr2 - s2 * zi2;
      zi2 = c2 * zi2 + s2 * zr2;
      zr2 = __r;
    } while (0);
    float c3;
    float s3 = k_sincos(tbase * 3, &c3);
    do {
      float4 __r = c3 * zr3 - s3 * zi3;
      zi3 = c3 * zi3 + s3 * zr3;
      zr3 = __r;
    } while (0);
  } while (0);

  barrier(0x01);

  lp = lds + me;

  lp[hook(3, 0 * 68)] = zr0.x;
  lp[hook(3, 1 * 68)] = zr0.y;
  lp[hook(3, 2 * 68)] = zr0.z;
  lp[hook(3, 3 * 68)] = zr0.w;
  lp += 68 * 4;

  lp[hook(3, 0 * 68)] = zr1.x;
  lp[hook(3, 1 * 68)] = zr1.y;
  lp[hook(3, 2 * 68)] = zr1.z;
  lp[hook(3, 3 * 68)] = zr1.w;
  lp += 68 * 4;

  lp[hook(3, 0 * 68)] = zr2.x;
  lp[hook(3, 1 * 68)] = zr2.y;
  lp[hook(3, 2 * 68)] = zr2.z;
  lp[hook(3, 3 * 68)] = zr2.w;
  lp += 68 * 4;

  lp[hook(3, 0 * 68)] = zr3.x;
  lp[hook(3, 1 * 68)] = zr3.y;
  lp[hook(3, 2 * 68)] = zr3.z;
  lp[hook(3, 3 * 68)] = zr3.w;
  lp += 68 * 4;

  lp[hook(3, 0 * 68)] = zi0.x;
  lp[hook(3, 1 * 68)] = zi0.y;
  lp[hook(3, 2 * 68)] = zi0.z;
  lp[hook(3, 3 * 68)] = zi0.w;
  lp += 68 * 4;

  lp[hook(3, 0 * 68)] = zi1.x;
  lp[hook(3, 1 * 68)] = zi1.y;
  lp[hook(3, 2 * 68)] = zi1.z;
  lp[hook(3, 3 * 68)] = zi1.w;
  lp += 68 * 4;

  lp[hook(3, 0 * 68)] = zi2.x;
  lp[hook(3, 1 * 68)] = zi2.y;
  lp[hook(3, 2 * 68)] = zi2.z;
  lp[hook(3, 3 * 68)] = zi2.w;
  lp += 68 * 4;

  lp[hook(3, 0 * 68)] = zi3.x;
  lp[hook(3, 1 * 68)] = zi3.y;
  lp[hook(3, 2 * 68)] = zi3.z;
  lp[hook(3, 3 * 68)] = zi3.w;

  barrier(0x01);
}

__attribute__((always_inline)) void kfft_pass5(unsigned int me, const local float* lds, global float* gr, global float* gi) {
  const local float* lp;

  lp = lds + ((me & 0xf) + (me >> 4) * (68 * 4));

  float4 zr0, zr1, zr2, zr3;

  zr0.x = lp[hook(3, 0 * 68)];
  zr0.y = lp[hook(3, 1 * 68)];
  zr0.z = lp[hook(3, 2 * 68)];
  zr0.w = lp[hook(3, 3 * 68)];
  lp += 16;

  zr1.x = lp[hook(3, 0 * 68)];
  zr1.y = lp[hook(3, 1 * 68)];
  zr1.z = lp[hook(3, 2 * 68)];
  zr1.w = lp[hook(3, 3 * 68)];
  lp += 16;

  zr2.x = lp[hook(3, 0 * 68)];
  zr2.y = lp[hook(3, 1 * 68)];
  zr2.z = lp[hook(3, 2 * 68)];
  zr2.w = lp[hook(3, 3 * 68)];
  lp += 16;

  zr3.x = lp[hook(3, 0 * 68)];
  zr3.y = lp[hook(3, 1 * 68)];
  zr3.z = lp[hook(3, 2 * 68)];
  zr3.w = lp[hook(3, 3 * 68)];

  lp += 68 * 4 * 4 - 3 * 16;

  float4 zi0, zi1, zi2, zi3;

  zi0.x = lp[hook(3, 0 * 68)];
  zi0.y = lp[hook(3, 1 * 68)];
  zi0.z = lp[hook(3, 2 * 68)];
  zi0.w = lp[hook(3, 3 * 68)];
  lp += 16;

  zi1.x = lp[hook(3, 0 * 68)];
  zi1.y = lp[hook(3, 1 * 68)];
  zi1.z = lp[hook(3, 2 * 68)];
  zi1.w = lp[hook(3, 3 * 68)];
  lp += 16;

  zi2.x = lp[hook(3, 0 * 68)];
  zi2.y = lp[hook(3, 1 * 68)];
  zi2.z = lp[hook(3, 2 * 68)];
  zi2.w = lp[hook(3, 3 * 68)];
  lp += 16;

  zi3.x = lp[hook(3, 0 * 68)];
  zi3.y = lp[hook(3, 1 * 68)];
  zi3.z = lp[hook(3, 2 * 68)];
  zi3.w = lp[hook(3, 3 * 68)];

  do {
    float4 ar0 = zr0 + zr2;
    float4 ar2 = zr1 + zr3;
    float4 br0 = ar0 + ar2;
    float4 br1 = zr0 - zr2;
    float4 br2 = ar0 - ar2;
    float4 br3 = zr1 - zr3;
    float4 ai0 = zi0 + zi2;
    float4 ai2 = zi1 + zi3;
    float4 bi0 = ai0 + ai2;
    float4 bi1 = zi0 - zi2;
    float4 bi2 = ai0 - ai2;
    float4 bi3 = zi1 - zi3;
    zr0 = br0;
    zi0 = bi0;
    zr1 = br1 + bi3;
    zi1 = bi1 - br3;
    zr3 = br1 - bi3;
    zi3 = br3 + bi1;
    zr2 = br2;
    zi2 = bi2;
  } while (0);

  global float4* gp = (global float4*)(gr + (me << 2));
  gp[hook(2, 0 * 64)] = zr0;
  gp[hook(2, 1 * 64)] = zr1;
  gp[hook(2, 2 * 64)] = zr2;
  gp[hook(2, 3 * 64)] = zr3;

  gp = (global float4*)(gi + (me << 2));
  gp[hook(2, 0 * 64)] = zi0;
  gp[hook(2, 1 * 64)] = zi1;
  gp[hook(2, 2 * 64)] = zi2;
  gp[hook(2, 3 * 64)] = zi3;
}
kernel void forward(global float* greal, global float* gimag) {
  local float lds[68 * 4 * 4 * 2];

  global float* gr;
  global float* gi;
  unsigned int gid = get_global_id(0);
  unsigned int me = gid & 0x3fU;
  unsigned int dg = (gid >> 6) * (1024 + 0);

  gr = greal + dg;
  gi = gimag + dg;

  kfft_pass1(me, gr, gi, lds);
  kfft_pass2(me, lds);
  kfft_pass3(me, lds);
  kfft_pass4(me, lds);
  kfft_pass5(me, lds, gr, gi);
}