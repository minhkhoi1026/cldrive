//{"activations":3,"allNeuralWeights":2,"excitationCount":1,"excitations":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute(global float* excitations, unsigned int excitationCount, global float* allNeuralWeights, global float* activations) {
  unsigned int neuralIndex = get_global_id(0);

  unsigned int offset = neuralIndex * excitationCount;
  float myExcitation = 0;
  for (unsigned int i = 0; i < excitationCount; i++) {
    myExcitation += excitations[hook(0, i)] * allNeuralWeights[hook(2, offset + i)];
  }
  activations[hook(3, neuralIndex)] = tanh(myExcitation);
}