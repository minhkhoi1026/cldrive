//{"layerActivation":1,"layerError":0,"layerThresholds":2,"learningRates":4,"numberOfNeurons":3}
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
kernel void updateThresholds(global const float* layerError, global const float* layerActivation, global float* layerThresholds, unsigned int numberOfNeurons, global const float* learningRates) {
  unsigned int neuronId = get_global_id(0);
  unsigned int networkId = get_global_id(1);
  unsigned int neuronOffset = offsetNeurons(networkId, neuronId, numberOfNeurons);
  layerThresholds[hook(2, neuronOffset)] = layerThresholds[hook(2, neuronOffset)] - layerActivation[hook(1, neuronOffset)] * layerError[hook(0, neuronOffset)] * learningRates[hook(4, networkId)];
}