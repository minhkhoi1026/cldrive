//{"layerActivation":1,"layerError":0,"layerSynapses":2,"learningRates":5,"numberOfNeurons":4,"prevNumberOfNeurons":3}
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
kernel void updateSynapses(global const float* layerError, global const float* layerActivation, global float* layerSynapses, unsigned int prevNumberOfNeurons, unsigned int numberOfNeurons, global const float* learningRates) {
  unsigned int neuronId = get_global_id(0);
  unsigned int networkId = get_global_id(1);

  unsigned int synapseOffset = offsetSynapses(networkId, neuronId, prevNumberOfNeurons, numberOfNeurons);
  unsigned int neuronOffset = offsetNeurons(networkId, neuronId, numberOfNeurons);

  for (unsigned int i = 0; i < prevNumberOfNeurons; i++) {
    layerSynapses[hook(2, synapseOffset + i)] = layerSynapses[hook(2, synapseOffset + i)] + layerActivation[hook(1, neuronOffset)] * layerError[hook(0, neuronOffset)] * learningRates[hook(5, networkId)];
  }
}