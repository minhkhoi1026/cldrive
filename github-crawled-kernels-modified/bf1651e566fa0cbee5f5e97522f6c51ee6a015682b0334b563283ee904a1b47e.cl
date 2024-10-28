//{"averageErrorDecay":4,"hiddenAverageErrorsBack":2,"hiddenAverageErrorsFront":3,"hiddenErrorSummationTemp":1,"hiddenStatesPrev":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t normalizedClampedNearestSampler = 1 | 4 | 0x10;
constant sampler_t normalizedClampedToEdgeNearestSampler = 1 | 2 | 0x10;
constant sampler_t unnormalizedClampedNearestSampler = 0 | 4 | 0x10;
constant sampler_t defaultNormalizedSampler = 1 | 2 | 0x10;
constant sampler_t defaultUnnormalizedSampler = 0 | 2 | 0x10;
float randFloat(uint2* state) {
  const float invMaxInt = 1.0f / 4294967296.0f;
  unsigned int x = (*state).x * 17 + (*state).y * 13123;
  (*state).x = (x << 13) ^ x;
  (*state).y ^= (x << 7);

  unsigned int tmp = x * (x * x * 15731 + 74323) + 871483;

  return convert_float(tmp) * invMaxInt;
}

float randNormal(uint2* state) {
  float u1 = randFloat(state);
  float u2 = randFloat(state);

  return sqrt(-2.0f * log(u1)) * cos(6.28318f * u2);
}

float sigmoid(float x) {
  return 1.0f / (1.0f + exp(-x));
}

bool inBounds0(int2 position, int2 upperBound) {
  return position.x >= 0 && position.x < upperBound.x && position.y >= 0 && position.y < upperBound.y;
}

bool inBounds(int2 position, int2 lowerBound, int2 upperBound) {
  return position.x >= lowerBound.x && position.x < upperBound.x && position.y >= lowerBound.y && position.y < upperBound.y;
}

kernel void spAverageErrors(read_only image2d_t hiddenStatesPrev, read_only image2d_t hiddenErrorSummationTemp, read_only image2d_t hiddenAverageErrorsBack, write_only image2d_t hiddenAverageErrorsFront, float averageErrorDecay) {
  int2 hiddenPosition = (int2)(get_global_id(0), get_global_id(1));

  float hiddenStatePrev = read_imagef(hiddenStatesPrev, hiddenPosition).x;

  float error = read_imagef(hiddenErrorSummationTemp, hiddenPosition).x * hiddenStatePrev;

  float averagePrev = read_imagef(hiddenAverageErrorsBack, hiddenPosition).x;

  float average = (1.0f - averageErrorDecay) * averagePrev + averageErrorDecay * error * error;

  write_imagef(hiddenAverageErrorsFront, hiddenPosition, (float4)(average));
}