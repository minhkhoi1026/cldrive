//{"feedBackRadius":10,"feedBackSize":6,"feedBackStates":1,"feedBackWeights":4,"hiddenSize":5,"hiddenStates":0,"predRadius":9,"predWeights":3,"predictThresholded":11,"predictions":2,"visibleToFeedBack":8,"visibleToHidden":7}
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

kernel void spDecode(read_only image2d_t hiddenStates, read_only image2d_t feedBackStates, write_only image2d_t predictions, read_only image3d_t predWeights, read_only image3d_t feedBackWeights, int2 hiddenSize, int2 feedBackSize, float2 visibleToHidden, float2 visibleToFeedBack, int predRadius, int feedBackRadius, uchar predictThresholded) {
  int2 visiblePosition = (int2)(get_global_id(0), get_global_id(1));
  int2 hiddenPositionCenter = (int2)(visiblePosition.x * visibleToHidden.x + 0.5f, visiblePosition.y * visibleToHidden.y + 0.5f);
  int2 feedBackPositionCenter = (int2)(visiblePosition.x * visibleToFeedBack.x + 0.5f, visiblePosition.y * visibleToFeedBack.y + 0.5f);

  int2 hiddenFieldLowerBound = hiddenPositionCenter - (int2)(predRadius);
  int2 feedBackFieldLowerBound = feedBackPositionCenter - (int2)(feedBackRadius);

  float sum = 0.0f;

  for (int dx = -predRadius; dx <= predRadius; dx++)
    for (int dy = -predRadius; dy <= predRadius; dy++) {
      int2 hiddenPosition = hiddenPositionCenter + (int2)(dx, dy);

      if (inBounds0(hiddenPosition, hiddenSize)) {
        int2 offset = hiddenPosition - hiddenFieldLowerBound;

        int wi = offset.y + offset.x * (predRadius * 2 + 1);

        float weight = read_imagef(predWeights, (int4)(visiblePosition.x, visiblePosition.y, wi, 0)).x;

        float state = read_imagef(hiddenStates, hiddenPosition).x;

        sum += state * weight;
      }
    }

  for (int dx = -feedBackRadius; dx <= feedBackRadius; dx++)
    for (int dy = -feedBackRadius; dy <= feedBackRadius; dy++) {
      int2 feedBackPosition = feedBackPositionCenter + (int2)(dx, dy);

      if (inBounds0(feedBackPosition, feedBackSize)) {
        int2 offset = feedBackPosition - feedBackFieldLowerBound;

        int wi = offset.y + offset.x * (feedBackRadius * 2 + 1);

        float weight = read_imagef(feedBackWeights, (int4)(visiblePosition.x, visiblePosition.y, wi, 0)).x;

        float state = read_imagef(feedBackStates, feedBackPosition).x;

        sum += state * weight;
      }
    }

  write_imagef(predictions, visiblePosition, (float4)(predictThresholded ? (sum > 0.5f ? 1.0f : 0.0f) : sum));
}