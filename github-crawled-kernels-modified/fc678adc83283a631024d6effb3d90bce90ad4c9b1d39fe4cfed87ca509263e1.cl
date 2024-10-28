//{"hiddenSize":3,"hiddenStates":0,"qStates":2,"qToHidden":4,"radius":5,"weights":1}
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
constant float minFloatEpsilon = 0.0001f;
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

float relu(float x, float leak) {
  if (x > 1.0f)
    return 1.0f + (x - 1.0f) * leak;

  return x > 0.0f ? x : x * leak;
}

float relud(float x, float leak) {
  return x > 0.0f && x < 1.0f ? 1.0f : leak;
}

float elu(float x, float alpha) {
  return x >= 0.0f ? x : alpha * (exp(x) - 1.0f);
}

float elud(float x, float alpha) {
  return x >= 0.0f ? 1.0f : x + alpha;
}

bool inBounds0(int2 position, int2 upperBound) {
  return position.x >= 0 && position.x < upperBound.x && position.y >= 0 && position.y < upperBound.y;
}

bool inBounds(int2 position, int2 lowerBound, int2 upperBound) {
  return position.x >= lowerBound.x && position.x < upperBound.x && position.y >= lowerBound.y && position.y < upperBound.y;
}

kernel void swarmQActivateToQ(read_only image2d_t hiddenStates, read_only image3d_t weights, write_only image2d_t qStates, int2 hiddenSize, float2 qToHidden, int radius) {
  int2 qPosition = (int2)(get_global_id(0), get_global_id(1));
  int2 hiddenPositionCenter = (int2)(qPosition.x * qToHidden.x + 0.5f, qPosition.y * qToHidden.y + 0.5f);

  float sum = 0.0f;

  int2 fieldLowerBound = hiddenPositionCenter - (int2)(radius);

  for (int dx = -radius; dx <= radius; dx++)
    for (int dy = -radius; dy <= radius; dy++) {
      int2 hiddenPosition = hiddenPositionCenter + (int2)(dx, dy);

      if (inBounds0(hiddenPosition, hiddenSize)) {
        int2 offset = hiddenPosition - fieldLowerBound;

        int wi = offset.y + offset.x * (radius * 2 + 1);

        float2 weight = read_imagef(weights, (int4)(qPosition.x, qPosition.y, wi, 0)).xy;

        float2 state = read_imagef(hiddenStates, hiddenPosition).xy;

        sum += dot(weight, state);
      }
    }

  write_imagef(qStates, qPosition, (float4)(sum));
}