//{"hiddenSummationTempBack":1,"hiddenSummationTempFront":2,"hiddenToVisible":5,"ignoreMiddle":7,"radius":6,"visibleSize":4,"visibleStates":0,"weights":3}
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

kernel void spEncode(read_only image2d_t visibleStates, read_only image2d_t hiddenSummationTempBack, write_only image2d_t hiddenSummationTempFront, read_only image3d_t weights, int2 visibleSize, float2 hiddenToVisible, int radius, uchar ignoreMiddle) {
  int2 hiddenPosition = (int2)(get_global_id(0), get_global_id(1));
  int2 visiblePositionCenter = (int2)(hiddenPosition.x * hiddenToVisible.x + 0.5f, hiddenPosition.y * hiddenToVisible.y + 0.5f);

  float sum = read_imagef(hiddenSummationTempBack, hiddenPosition).x;

  int2 fieldLowerBound = visiblePositionCenter - (int2)(radius);

  for (int dx = -radius; dx <= radius; dx++)
    for (int dy = -radius; dy <= radius; dy++) {
      if (ignoreMiddle && dx == 0 && dy == 0)
        continue;

      int2 visiblePosition = visiblePositionCenter + (int2)(dx, dy);

      if (inBounds0(visiblePosition, visibleSize)) {
        int2 offset = visiblePosition - fieldLowerBound;

        int wi = offset.y + offset.x * (radius * 2 + 1);

        float weight = read_imagef(weights, (int4)(hiddenPosition.x, hiddenPosition.y, wi, 0)).x;

        float state = read_imagef(visibleStates, visiblePosition).x;

        sum += state * weight;
      }
    }

  write_imagef(hiddenSummationTempFront, hiddenPosition, (float4)(sum));
}