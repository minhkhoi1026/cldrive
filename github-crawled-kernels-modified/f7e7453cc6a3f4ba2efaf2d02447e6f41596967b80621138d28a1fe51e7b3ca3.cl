//{"accumulator":2,"output":3,"paths":1,"sampleWeight":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 debugToneMapAndGammaCorrect(float3 sample);
float3 debugToneMapAndGammaCorrect(float3 sample) {
  sample *= 1.0f;

  float3 mapped = sample / (sample + 1.0f);
  return clamp(pow(mapped, 1.0f / 2.2f), 0.0f, 1.0f) * 255.0f;
}

kernel void debugAccumulator(const float sampleWeight, global Path* paths, global float3* accumulator, global uchar4* output) {
  int globalId = get_global_id(0);

  float3 val = debugToneMapAndGammaCorrect(accumulator[hook(2, globalId)] * sampleWeight);
  output[hook(3, globalId)] = (uchar4)((uchar)val.x, (uchar)val.y, (uchar)val.z, 255);
}