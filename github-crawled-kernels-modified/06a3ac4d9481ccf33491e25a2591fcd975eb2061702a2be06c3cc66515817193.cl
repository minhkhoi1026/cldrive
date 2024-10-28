//{"layerError":3,"layerSynapses":4,"numberOfNeurons":5,"prevLayerError":1,"prevLayerInput":0,"prevNumberOfNeurons":2}
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
kernel void computePrevLayerError(

    global const float* prevLayerInput, global float* prevLayerError, unsigned int prevNumberOfNeurons,

    global const float* layerError, global const float* layerSynapses, unsigned int numberOfNeurons) {
  unsigned int neuronId = get_global_id(0);
  unsigned int networkId = get_global_id(1);

  unsigned int prevNeuronOffset = offsetNeurons(networkId, neuronId, prevNumberOfNeurons);

  unsigned int neuronOffset = offsetNeurons(networkId, 0, numberOfNeurons);
  unsigned int synapseOffset;

  int i = 0;
  float input = 0;
  for (i = 0; i < numberOfNeurons; i++) {
    synapseOffset = offsetSynapses(networkId, i, prevNumberOfNeurons, numberOfNeurons) + neuronId;
    input = input + layerError[hook(3, neuronOffset + i)] * layerSynapses[hook(4, synapseOffset)];
  }
  prevLayerError[hook(1, prevNeuronOffset)] = input * slopeAt(prevLayerInput[hook(0, prevNeuronOffset)]);
}