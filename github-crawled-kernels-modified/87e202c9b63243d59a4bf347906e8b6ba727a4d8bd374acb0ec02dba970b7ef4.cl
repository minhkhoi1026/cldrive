//{"dataRow":2,"dataRowWidth":1,"dataSet":0,"layerActivation":4,"layerError":5,"layerInput":3,"numberOfNeurons":6}
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
kernel void computeOutputError(

    global float* dataSet, unsigned int dataRowWidth, unsigned int dataRow,

    global float* layerInput, global float* layerActivation, global float* layerError, unsigned int numberOfNeurons) {
  unsigned int neuronId = get_global_id(0);
  unsigned int networkId = get_global_id(1);

  unsigned int neuronOffset = offsetNeurons(networkId, neuronId, numberOfNeurons);
  unsigned int dataSetOffset = dataRowWidth * dataRow + neuronId;

  layerError[hook(5, neuronOffset)] = slopeAt(layerInput[hook(3, neuronOffset)]) * (dataSet[hook(0, dataSetOffset)] - layerActivation[hook(4, neuronOffset)]);
}