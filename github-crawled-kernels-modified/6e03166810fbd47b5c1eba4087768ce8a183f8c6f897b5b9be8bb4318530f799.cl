//{"channelStride":2,"fadeBuffer":0,"outputBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void crossfade(global float* fadeBuffer, global float* outputBuffer, int channelStride) {
  int sampleId = get_global_id(0);
  int numSamples = get_global_size(0);
  int chId = get_global_id(1);
  int sampleOffset = sampleId + chId * channelStride;
  outputBuffer[hook(1, sampleOffset)] = (outputBuffer[hook(1, sampleOffset)] * sampleId + fadeBuffer[hook(0, sampleOffset)] * (numSamples - sampleId)) / (float)numSamples;
}