//{"bufferInput":0,"bufferOutput":5,"inOutPos":6,"inputHistory":1,"inputTaps":3,"numInputTaps":7,"numOutputTaps":8,"numSamples":9,"outputHistory":2,"outputTaps":4,"pBufferInput":11,"pBufferOutput":15,"pInputHistory":10,"pInputTaps":12,"pOutputHistory":14,"pOutputTaps":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void IIRfilter(global float* bufferInput, global float* inputHistory, global float* outputHistory, global float* inputTaps, global float* outputTaps, global float* bufferOutput, global int* inOutPos, int numInputTaps, int numOutputTaps, int numSamples) {
  unsigned int idx = get_global_id(0);
  unsigned int chan = get_global_id(1);

  global float* pBufferInput = &bufferInput[hook(0, chan * numSamples)];
  global float* pInputHistory = &inputHistory[hook(1, chan * numInputTaps)];
  global float* pOutputHistory = &outputHistory[hook(2, chan * numOutputTaps)];
  global float* pInputTaps = &inputTaps[hook(3, chan * numInputTaps)];
  global float* pOutputTaps = &outputTaps[hook(4, chan * numOutputTaps)];
  global float* pBufferOutput = &bufferOutput[hook(5, chan * numSamples)];

  int inputHistPos = inOutPos[hook(6, 0)];
  int outputHistPos = inOutPos[hook(6, 1)];

  float sample;
  for (int sn = 0; sn < numSamples; sn++) {
    sample = 0.0;
    pInputHistory[hook(10, inputHistPos)] = pBufferInput[hook(11, sn)];

    for (int k = 0; k < numInputTaps; k++) {
      sample += pInputTaps[hook(12, k)] * pInputHistory[hook(10, (inputHistPos + numInputTaps - k) % numInputTaps)];
    }

    for (int l = 0; l < numOutputTaps; l++) {
      sample += pOutputTaps[hook(13, l)] * pOutputHistory[hook(14, (outputHistPos + numOutputTaps - l) % numOutputTaps)];
    }
    pBufferOutput[hook(15, sn)] = sample;

    ++inputHistPos;
    ++outputHistPos;

    inputHistPos = (inputHistPos % numInputTaps);
    outputHistPos = (outputHistPos % numOutputTaps);
    pOutputHistory[hook(14, outputHistPos)] = pBufferOutput[hook(15, sn)];
  }

  inOutPos[hook(6, 0)] = inputHistPos;
  inOutPos[hook(6, 1)] = outputHistPos;
}