//{"aa":4,"bias":1,"biasOffset":3,"biasWeights":2,"layerSize":0,"typeFunction":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float boundRange(float x, float lowerLimit, float upperLimit) {
  return (x < lowerLimit ? lowerLimit : (x > upperLimit ? upperLimit : x));
}

float Logistic_fn(float x) {
  if (x < 88.722839f) {
    if (x > -88.722839f)
      return (float)1.0 / ((float)1.0 + exp(-x));
    else
      return 0;
  }

  return 1;
}

float Maxmin1_fn(float x) {
  return ((float)2.0 * Logistic_fn(x) - (float)1.0);
}

float Tanh_fn(float x) {
  return Maxmin1_fn((float)2.0 * x);
}

float Identity_fn(float x) {
  return x;
}

kernel void ffl_computeOutputFn(int layerSize, float bias, global float* biasWeights, int biasOffset, global float* aa, int typeFunction) {
  int outputIdx = get_global_id(0);

  int blockIdx = outputIdx % layerSize;
  float a = aa[hook(4, outputIdx)];

  a += bias * biasWeights[hook(2, biasOffset + blockIdx)];

  float b;
  if (typeFunction == 0)
    b = Tanh_fn(a);
  else if (typeFunction == 1)
    b = Logistic_fn(a);
  else
    b = Identity_fn(a);
  aa[hook(4, outputIdx)] = b;
}