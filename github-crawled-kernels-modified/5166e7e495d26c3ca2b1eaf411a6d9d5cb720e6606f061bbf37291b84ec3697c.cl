//{"deltaInput":0,"deltaOutput":1,"inputArea":5,"inputVolume":4,"miniBatchSize":8,"outputArea":7,"outputVolume":6,"poolingTable":3,"switches":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MaxPoolingBackward(global float* deltaInput, global float* deltaOutput, global bool* switches, global int* poolingTable, const int inputVolume, const int inputArea, const int outputVolume, const int outputArea, const int miniBatchSize) {
  const int iOutput = get_global_id(0);

  if (iOutput < outputVolume * miniBatchSize) {
    int iExample = iOutput / outputVolume;
    int iChannel = (iOutput % outputVolume) / outputArea;
    int iInputChannelBeginning = iExample * inputVolume + iChannel * inputArea;

    int iOutputWithinChannel = iOutput % outputArea;

    for (int i = 0; i < 4; i++) {
      int iInput = iInputChannelBeginning + poolingTable[hook(3, 4 * iOutputWithinChannel + i)];
      if (switches[hook(2, iInput)])
        deltaInput[hook(0, iInput)] = deltaOutput[hook(1, iOutput)];
      else
        deltaInput[hook(0, iInput)] = 0.0f;
    }
  }
}