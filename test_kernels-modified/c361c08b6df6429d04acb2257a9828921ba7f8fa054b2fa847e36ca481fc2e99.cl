//{"<recovery-expr>()":2,"output":1,"paths":0}
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

kernel void debugThroughput(global Path* paths, global uchar4* output) {
  int globalId = get_global_id(0);
  unsigned int pixelIndex = paths[hook(2, globalId)].pixelIndex;

  float3 val = debugToneMapAndGammaCorrect(paths[hook(2, globalId)].throughput);
  output[hook(1, pixelIndex)] = (uchar4)((uchar)val.x, (uchar)val.y, (uchar)val.z, 255);
}