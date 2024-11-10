//{"activations":2,"activeRatio":5,"radius":4,"size":3,"states":1,"sums":0}
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

kernel void predSolveHiddenSwarm(read_only image2d_t sums, write_only image2d_t states, write_only image2d_t activations, int2 size, int radius, float activeRatio) {
  int2 position = (int2)(get_global_id(0), get_global_id(1));

  float2 sum = read_imagef(sums, position).xy;

  float inhibition = 0.0f;

  float counter = 0.0f;

  for (int dx = -radius; dx <= radius; dx++)
    for (int dy = -radius; dy <= radius; dy++) {
      if (dx == 0 && dy == 0)
        continue;

      int2 otherPosition = position + (int2)(dx, dy);

      if (inBounds0(otherPosition, size)) {
        float otherSum = read_imagef(sums, otherPosition).x;

        inhibition += otherSum >= sum.x ? 1.0f : 0.0f;

        counter++;
      }
    }

  float state = inhibition < (counter * activeRatio) ? 1.0f : 0.0f;

  write_imagef(states, position, (float4)(state, sum.y, 0.0f, 0.0f));
  write_imagef(activations, position, (float4)(sum.x, sum.y, 0.0f, 0.0f));
}