//{"alpha":4,"inputCount":3,"inputs":0,"outputs":2,"weights":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ActivationNeuron(global float* inputs, global float* weights, global float* outputs, global int* inputCount, global float* alpha) {
  int outputIndex = get_global_id(0);

  float sum = 0.0;

  for (int inputIndex = 0; inputIndex < inputCount[hook(3, 0)]; inputIndex++) {
    int weightIndex = inputCount[hook(3, 0)] * outputIndex + inputIndex;
    sum += inputs[hook(0, inputIndex)] * weights[hook(1, weightIndex)];
  }

  outputs[hook(2, outputIndex)] = (2.0 / (1.0 + native_exp(-alpha[hook(4, 0)] * sum))) - 1.0;
}