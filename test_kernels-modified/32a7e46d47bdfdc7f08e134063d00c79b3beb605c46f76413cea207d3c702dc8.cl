//{"inputBuffer":0,"inputStride":2,"numOfChannels":3,"outputBuffer":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Mixer(global float* inputBuffer, global float* outputBuffer, int inputStride, int numOfChannels) {
  int sampId = get_global_id(0);

  float sum = 0;
  for (int i = 0; i < numOfChannels; i++) {
    sum += inputBuffer[hook(0, i * inputStride + sampId)];
  }

  outputBuffer[hook(1, sampId)] = sum;
}