//{"image":0,"intensityProfile":4,"lineSearchDistance":2,"points":1,"results":5,"sampleSpacing":3,"size":8,"spacingX":6,"spacingY":7,"transformationMatrix":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
float3 transform(const float3 position, constant float* transformationMatrix) {
  float3 result;
  result.x = position.x * transformationMatrix[hook(9, 0)] + position.y * transformationMatrix[hook(9, 1)] + position.z * transformationMatrix[hook(9, 2)] + transformationMatrix[hook(9, 3)];
  result.y = position.x * transformationMatrix[hook(9, 4)] + position.y * transformationMatrix[hook(9, 5)] + position.z * transformationMatrix[hook(9, 6)] + transformationMatrix[hook(9, 7)];
  result.z = position.x * transformationMatrix[hook(9, 8)] + position.y * transformationMatrix[hook(9, 9)] + position.z * transformationMatrix[hook(9, 10)] + transformationMatrix[hook(9, 11)];
  return result;
}

kernel void edgeDetection2D(read_only image2d_t image, global float* points, private float lineSearchDistance, private float sampleSpacing, local float* intensityProfile, global float* results, private float spacingX, private float spacingY, private int size) {
  const int sampleNr = get_global_id(0);
  const int pointNr = get_global_id(1);
  const int nrOfSamples = get_global_size(0);
  const float2 position = vload2(pointNr * 2, points);
  const float2 normal = vload2(pointNr * 2 + 1, points);
  const float distance = -lineSearchDistance / 2.0f + sampleNr * sampleSpacing;

  float2 samplePosition = position + distance * normal;
  samplePosition.x /= spacingX;
  samplePosition.y /= spacingY;

  intensityProfile[hook(4, sampleNr)] = (float)read_imageui(image, sampler, samplePosition).x;

  barrier(0x01);

  float sumBeforeRidge = 0.0f;
  float sumInRidge = 0.0f;
  float sumAfterRidge = 0.0f;
  int startPos = -1;
  int endPos = -1;
  for (int i = 0; i < nrOfSamples; i++) {
    if (startPos == -1 && intensityProfile[hook(4, i)] > 0)
      startPos = i;
    if (startPos >= 0 && intensityProfile[hook(4, i)] == 0) {
      endPos = i;
    }
    if (startPos >= 0 && endPos == -1) {
      if (i <= sampleNr) {
        sumBeforeRidge += intensityProfile[hook(4, i)];
      } else if (i <= sampleNr + size) {
        sumInRidge += intensityProfile[hook(4, i)];
      }
    }
  }
  if (endPos < 0)
    endPos = nrOfSamples - 1;

  const float averageBeforeRidge = sumBeforeRidge / (sampleNr + 1 - startPos);
  const float averageInRidge = sumInRidge / size;

  const float intensityDifference = averageInRidge - averageBeforeRidge;

  results[hook(5, sampleNr + pointNr * nrOfSamples)] = intensityDifference;
}