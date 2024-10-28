//{"errors":0,"hiddenErrorSummationTempBack":1,"hiddenErrorSummationTempFront":2,"hiddenSize":5,"hiddenToVisible":7,"predRadius":8,"predWeights":3,"reversePredDecodeRadii":9,"visibleSize":4,"visibleToHidden":6}
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

kernel void spErrorPropagation(read_only image2d_t errors, read_only image2d_t hiddenErrorSummationTempBack, write_only image2d_t hiddenErrorSummationTempFront, read_only image3d_t predWeights, int2 visibleSize, int2 hiddenSize, float2 visibleToHidden, float2 hiddenToVisible, int predRadius, int2 reversePredDecodeRadii) {
  int2 hiddenPosition = (int2)(get_global_id(0), get_global_id(1));
  int2 visiblePositionCenter = (int2)(hiddenPosition.x * hiddenToVisible.x + 0.5f, hiddenPosition.y * hiddenToVisible.y + 0.5f);

  float error = read_imagef(hiddenErrorSummationTempBack, hiddenPosition).x;

  for (int dx = -reversePredDecodeRadii.x; dx <= reversePredDecodeRadii.x; dx++)
    for (int dy = -reversePredDecodeRadii.y; dy <= reversePredDecodeRadii.y; dy++) {
      int2 visiblePosition = visiblePositionCenter + (int2)(dx, dy);

      if (inBounds0(visiblePosition, visibleSize)) {
        int2 fieldCenter = (int2)(visiblePosition.x * visibleToHidden.x + 0.5f, visiblePosition.y * visibleToHidden.y + 0.5f);

        int2 fieldLowerBound = fieldCenter - (int2)(predRadius);
        int2 fieldUpperBound = fieldCenter + (int2)(predRadius + 1);

        if (inBounds(hiddenPosition, fieldLowerBound, fieldUpperBound)) {
          int2 offset = hiddenPosition - fieldLowerBound;

          float visibleError = read_imagef(errors, visiblePosition).x;

          int wi = offset.y + offset.x * (predRadius * 2 + 1);

          float weight = read_imagef(predWeights, (int4)(visiblePosition.x, visiblePosition.y, wi, 0)).x;

          error += visibleError * weight;
        }
      }
    }

  write_imagef(hiddenErrorSummationTempFront, hiddenPosition, (float4)(error));
}