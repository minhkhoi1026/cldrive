//{"biases":1,"config":3,"output":4,"prevActivation":2,"weightMx":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float ActivationFunction(int functionId, float x) {
  switch (functionId) {
    case 1:
      return 1.0f / (1.0f + exp(-x));
    case 0:
    default:
      return x;
  }
}

float ActivationFunctionPrime(int functionId, float x) {
  switch (functionId) {
    case 1: {
      const float sigm = 1.0f / (1.0f + exp(-x));
      return sigm * (1.0f - sigm);
    }
    case 0:
    default:
      return 0;
  }
}

float CostFunctionDelta(int costFunctionId, int activationFunctionId, float z, float a, float desiredOutput) {
  switch (costFunctionId) {
    case 0:
      return (a - desiredOutput) * ActivationFunctionPrime(activationFunctionId, z);
    case 1:
    default:
      return a - desiredOutput;
  }
}

kernel void calcSingleLayer(global const float* weightMx, global const float* biases, global const float* prevActivation, constant const int* config, global float* output) {
  const int rowCount = config[hook(3, 0)];
  const int colCount = config[hook(3, 1)];
  const int activationFunctionId = config[hook(3, 2)];

  const int rowId = get_global_id(0);

  if (rowId >= rowCount)
    return;

  float acc = 0;
  for (int i = 0; i < colCount; ++i)
    acc += weightMx[hook(0, (rowId * colCount) + i)] * prevActivation[hook(2, i)];
  acc += biases[hook(1, rowId)];

  acc = ActivationFunction(activationFunctionId, acc);

  output[hook(4, rowId)] = acc;
}