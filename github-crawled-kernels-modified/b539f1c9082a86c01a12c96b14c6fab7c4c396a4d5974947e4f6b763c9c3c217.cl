//{"actualoutput":2,"layerSize":0,"outputErrors":4,"patTypes":1,"targets":3}
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

float Tanh_deriv(float y) {
  return (float)1.0 - (y * y);
}
float Logistic_deriv(float y) {
  return y * ((float)1.0 - y);
}
float Identity_deriv(float y) {
  return 1;
}
kernel void spol_computeOutputErrorFn(int layerSize, global char* patTypes, global float* actualoutput, global float* targets, global float* outputErrors) {
  int outputIdx = get_global_id(0);

  float actualOutput = actualoutput[hook(2, outputIdx)];
  float targetOutput = targets[hook(3, outputIdx)];

  int patIdx = outputIdx / layerSize;

  if (patTypes[hook(1, patIdx)] == 0)
    outputErrors[hook(4, outputIdx)] = 0;
  else
    outputErrors[hook(4, outputIdx)] = actualOutput - targetOutput;
}