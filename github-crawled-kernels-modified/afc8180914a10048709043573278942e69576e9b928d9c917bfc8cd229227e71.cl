//{"inputs":0,"outputs":1,"samples":5,"sizeIn":3,"sizeOut":4,"weights":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float activation_function(float x) {
  return 1.f / (1 + exp(-x));
}

kernel void execute(constant float* inputs, global float* outputs, constant float* weights, const unsigned int sizeIn, const unsigned int sizeOut, const unsigned int samples) {
  const unsigned int personId = get_global_id(0);
  const unsigned int sampleId = get_global_id(1);
  const unsigned int outputId = get_global_id(2);

  const unsigned int lastInputId = (personId * samples + sampleId + 1) * sizeIn;

  float outputNeuron = 0;

  for (unsigned int inputId = lastInputId - sizeIn, weightId = sizeIn * sizeOut * personId + outputId; inputId < lastInputId; ++inputId, weightId += sizeOut) {
    outputNeuron += weights[hook(2, weightId)] * inputs[hook(0, inputId)];
  }

  outputs[hook(1, (personId * samples + sampleId) * sizeOut + outputId)] = activation_function(outputNeuron);
  return;
}