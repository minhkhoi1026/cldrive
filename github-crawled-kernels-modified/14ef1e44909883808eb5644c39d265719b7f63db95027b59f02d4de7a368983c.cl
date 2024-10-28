//{"layerActivation":3,"layerInput":2,"layerSynapses":5,"layerThresholds":4,"numberOfNeurons":6,"prevLayerActivation":0,"prevNumberOfNeurons":1}
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
kernel void computeNextLayer(

    global const float* prevLayerActivation, unsigned int prevNumberOfNeurons,

    global float* layerInput, global float* layerActivation, global const float* layerThresholds, global const float* layerSynapses, unsigned int numberOfNeurons) {
  unsigned int neuronId = get_global_id(0);
  unsigned int networkId = get_global_id(1);

  unsigned int prevNeuronOffset = offsetNeurons(networkId, 0, prevNumberOfNeurons);

  unsigned int neuronOffset = offsetNeurons(networkId, neuronId, numberOfNeurons);

  unsigned int synapsesOffset = offsetSynapses(networkId, neuronId, prevNumberOfNeurons, numberOfNeurons);

  int i = 0;
  float input = 0.0f;
  for (i = 0; i < prevNumberOfNeurons; i++) {
    input = input + prevLayerActivation[hook(0, prevNeuronOffset + i)] * layerSynapses[hook(5, synapsesOffset + i)];
  }
  input = input - layerThresholds[hook(4, neuronOffset)];
  layerInput[hook(2, neuronOffset)] = input;
  layerActivation[hook(3, neuronOffset)] = valueAt(input);
}