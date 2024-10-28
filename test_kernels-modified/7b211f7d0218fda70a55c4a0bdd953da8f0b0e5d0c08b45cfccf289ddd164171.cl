//{"iPoolingField":9,"input":1,"inputArea":5,"inputVolume":4,"miniBatchSize":8,"output":0,"outputArea":7,"outputVolume":6,"poolingField":10,"poolingTable":3,"switches":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void MaxPoolingForward(global float* output, global float* input, global bool* switches, global int* poolingTable, const int inputVolume, const int inputArea, const int outputVolume, const int outputArea, const int miniBatchSize) {
  const int iOutput = get_global_id(0);

  if (iOutput < outputVolume * miniBatchSize) {
    int iExample = iOutput / outputVolume;
    int iChannel = (iOutput % outputVolume) / outputArea;
    int iOutputWithinChannel = iOutput % outputArea;

    int iInputChannelBeginning = iExample * inputVolume + iChannel * inputArea;

    int iPoolingField[4];
    float poolingField[4];
    for (int i = 0; i < 4; i++) {
      iPoolingField[hook(9, i)] = iInputChannelBeginning + poolingTable[hook(3, 4 * iOutputWithinChannel + i)];
      poolingField[hook(10, i)] = input[hook(1, iPoolingField[ihook(9, i))];
    }

    float maxInput = -(__builtin_inff());
    for (int i = 0; i < 4; i++) {
      if (poolingField[hook(10, i)] > maxInput)
        maxInput = poolingField[hook(10, i)];
    }
    output[hook(0, iOutput)] = maxInput;

    for (int i = 0; i < 4; i++) {
      switches[hook(2, iPoolingField[ihook(9, i))] = (poolingField[hook(10, i)] == maxInput) ? true : false;
    }
  }
}