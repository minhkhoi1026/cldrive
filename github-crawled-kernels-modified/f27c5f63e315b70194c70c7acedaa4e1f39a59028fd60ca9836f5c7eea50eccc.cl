//{"dataRow":3,"dataRowWidth":2,"dataSet":0,"inputMasks":1,"layerActivation":5,"layerInput":4,"layerSynapses":7,"layerThresholds":6,"numberOfNeurons":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline unsigned int offsetSynapses(unsigned int networkId, unsigned int neuronId, unsigned int inNeurons, unsigned int outNeurons) {
  return (networkId * inNeurons * outNeurons) + (neuronId * inNeurons);
}
inline unsigned int offsetNeurons(unsigned int networkId, unsigned int neuronId, unsigned int neurons) {
  return neurons * networkId + neuronId;
}

inline float valueAt(float value) {
  return 1.0 / (1.0 + exp(-1.0 * value));
}

inline float slopeAt(float value) {
  float pos = valueAt(value);
  return pos * (1.0 - pos);
}
kernel void computeInputLayer(

    global const float* dataSet, global const float* inputMasks, const unsigned int dataRowWidth, const unsigned int dataRow,

    global float* layerInput, global float* layerActivation, global const float* layerThresholds, global const float* layerSynapses, const unsigned int numberOfNeurons) {
  unsigned int neuronId = get_global_id(0);
  unsigned int networkId = get_global_id(1);

  unsigned int neuronOffset = offsetNeurons(networkId, neuronId, numberOfNeurons);

  unsigned int dataSetOffset = dataRowWidth * dataRow;

  unsigned int synapsesOffset = offsetSynapses(networkId, neuronId, dataRowWidth, numberOfNeurons);

  unsigned int i = 0;
  float input = 0.0f;
  for (i = 0; i < dataRowWidth; i++) {
    input = input + dataSet[hook(0, dataSetOffset + i)] * layerSynapses[hook(7, synapsesOffset + i)] * inputMasks[hook(1, networkId * dataRowWidth + i)];
  }
  input = input - layerThresholds[hook(6, neuronOffset)];
  layerInput[hook(4, neuronOffset)] = input;
  layerActivation[hook(5, neuronOffset)] = valueAt(input);
}