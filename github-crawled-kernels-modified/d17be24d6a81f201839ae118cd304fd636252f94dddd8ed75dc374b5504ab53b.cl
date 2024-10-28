//{"output":0}
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

kernel void debugClearBuffer(global uchar4* output) {
  output[hook(0, get_global_id(0))] = (uchar4)(0, 0, 0, 255);
}