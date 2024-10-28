//{"gradients":1,"image":0,"result":2,"spacing":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
constant sampler_t samplerInterpolation = 0 | 4 | 0x20;
bool outOfBounds(int2 pos, float radius, unsigned int width, unsigned int height) {
  return pos.x - radius < 0 || pos.y - radius < 0 || pos.x + radius >= width || pos.y + radius >= height;
}

kernel void vesselDetection(read_only image2d_t image, read_only image2d_t gradients, write_only image2d_t result, float spacing) {
  const float radiusMinInMM = 3.5;
  const float radiusMaxInMM = 6;
  const float scaleStep = 0.1;
  const unsigned int samples = 32;
  const float radiusMinInPixels = radiusMinInMM * (1.0f / spacing);
  const float radiusMaxInPixels = radiusMaxInMM * (1.0f / spacing);
  const float radiusStepInPixels = 2;

  const int2 pos = {get_global_id(0) * 4, get_global_id(1) * 4};

  if (outOfBounds(pos, 10, get_image_width(image), get_image_height(image))) {
    write_imagef(result, pos, (float4)(0, 0, 0, 0));
    return;
  }

  float bestFitness = -100;
  float bestRadius = 0;
  float bestScale = 0;
  for (float scale = 1.0; scale >= 0.5; scale -= scaleStep) {
    float sumLumenIntensity = 0;
    uchar radiusCounter = 0;
    for (float radius = 2; radius <= radiusMaxInPixels; radius += radiusStepInPixels) {
      float fitness = 0;
      float intensity = 0;

      for (unsigned int i = 0; i < samples; i++) {
        const float alpha = (float)(2.0f * 3.14159265358979323846 * i) / samples;
        float2 direction = {cos(alpha), sin(alpha) * scale};
        const float2 samplePos = direction * radius + convert_float2(pos);
        float2 gradient = read_imagef(gradients, samplerInterpolation, samplePos).xy;

        float2 normal = {scale * radius * cos(alpha), radius * sin(alpha)};
        normal = normalize(normal);
        fitness += dot(gradient, normal);
        intensity += read_imageui(image, samplerInterpolation, samplePos).x;
      }
      float averageLumenIntensity = sumLumenIntensity / (radiusCounter * samples);
      fitness = fitness / samples;
      if (fitness > bestFitness && radius > radiusMinInPixels) {
        float averageBorderIntensity = 0.0f;
        for (unsigned int i = 0; i < samples; i++) {
          const float alpha = (float)(2.0f * 3.14159265358979323846 * i) / samples;
          float2 direction = {cos(alpha), sin(alpha) * scale};
          const float2 samplePos = direction * (radius + radiusStepInPixels) + convert_float2(pos);
          averageBorderIntensity += read_imageui(image, samplerInterpolation, samplePos).x;
        }
        averageBorderIntensity /= samples;
        if ((averageBorderIntensity - averageLumenIntensity) / averageBorderIntensity > 0.5) {
          bestFitness = fitness;
          bestRadius = radius;
          bestScale = scale;
        }
      }
      radiusCounter++;
      sumLumenIntensity += intensity;
    }
  }

  write_imagef(result, pos, (float4)(bestFitness, bestRadius, bestScale, pos.x + pos.y * get_image_width(image)));
}