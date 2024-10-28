//{"accumulator":0,"exposure":4,"frameBuffer":2,"paths":1,"sampleWeight":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void tonemapSimpleReinhard(global float3* accumulator, global Path* paths, global uchar4* frameBuffer, const float sampleWeight, const float exposure) {
  int globalId = get_global_id(0);

  float3 hdrColor = accumulator[hook(0, globalId)] * sampleWeight * exposure;
  float3 mapped = hdrColor / (hdrColor + 1.0f);

  float3 normalizedOutput = clamp(pow(mapped, 1.0f / 2.2f), 0.0f, 1.0f) * 255.0f;

  frameBuffer[hook(2, globalId)] = (uchar4)((uchar)normalizedOutput.r, (uchar)normalizedOutput.g, (uchar)normalizedOutput.b, 255);
}