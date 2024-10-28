//{"divisionSize":2,"input":0,"inputSize":3,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int MWC64X(uint2* state) {
  enum { A = 4294883355U };
  unsigned int x = (*state).x, c = (*state).y;
  unsigned int res = x ^ c;
  unsigned int hi = mul_hi(x, A);
  x = x * A + c;
  c = hi + (x < c);
  *state = (uint2)(x, c);
  return res;
}

unsigned int xorshift128(uint4* state) {
  unsigned int t = (*state).w;
  t ^= t << 11;
  t ^= t >> 8;
  (*state).w = (*state).z;
  (*state).z = (*state).y;
  (*state).y = (*state).x;
  t ^= (*state).x;
  t ^= (*state).x >> 19;
  (*state).x = t;
  return t;
}

unsigned int xorshift32(unsigned int* state) {
  unsigned int x = *state;
  x ^= x << 13;
  x ^= x >> 17;
  x ^= x << 5;
  *state = x;
  return x;
}

float2 generateNormals(uint2* seed, uint2* seed2) {
  float u1 = 0.5;
  float u2 = 0.5;
  float a = 0.0;
  float b = 0.0;
  float normal1 = 0.0;
  float normal2 = 0.0;
  unsigned int random1 = MWC64X(seed);
  if (random1 == 0) {
    random1 = MWC64X(seed);
  }
  unsigned int random2 = MWC64X(seed2);

  u1 = (float)random1 / (float)0xffffffff;
  u2 = (float)random2 / (float)0xffffffff;

  a = native_sqrt(-2 * native_log(u1));
  b = 2 * 3.14159265358979323846f * u2;

  normal1 = a * native_sin(b);
  normal2 = a * native_cos(b);

  return (float2)(normal1, normal2);
}

float generatePayoff(float const optionPrice, float const cumulativeWalk, unsigned int const steps) {
  float averageValue = cumulativeWalk / steps;
  float payOff = averageValue - optionPrice;
  if (payOff < 0.0) {
    return 0.0;
  } else {
    return payOff;
  }
}

float generateGeometricPayoff(float const optionPrice, float const cumulativeWalk, unsigned int const steps) {
  float averageValue = native_exp(cumulativeWalk / steps);
  float payOff = averageValue - optionPrice;
  if (payOff < 0.0) {
    return 0.0;
  } else {
    return payOff;
  }
}

kernel void averageKernel(global float* input, global float* output, unsigned int const divisionSize, unsigned int const inputSize) {
  unsigned int n = get_global_id(0);
  float outputInternal = 0;
  if ((n + 1) * divisionSize <= inputSize) {
    for (unsigned int i = 0; i < divisionSize; i++) {
      outputInternal += input[hook(0, n * divisionSize + i)];
    }
  } else {
    for (unsigned int i = 0; i < (n + 1) * divisionSize - inputSize; i++) {
      outputInternal += input[hook(0, n * divisionSize + i)];
    }
  }
  output[hook(1, n)] = outputInternal;
}