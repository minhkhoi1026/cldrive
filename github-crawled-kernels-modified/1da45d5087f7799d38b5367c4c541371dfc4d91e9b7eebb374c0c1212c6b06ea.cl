//{"layerSize":0,"outputErrors":2,"outputs":1,"targetClasses":3}
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
kernel void mcl_computeOutputErrorFn(int layerSize, global float* outputs, global float* outputErrors, global int* targetClasses) {
  int patIdx = get_global_id(0);

  int targetClass = targetClasses[hook(3, patIdx)];

  if (targetClass == -1)
    return;

  int outputIdx = patIdx * layerSize + targetClass;

  float targetProb = max(1.1754944e-038f, outputs[hook(1, outputIdx)]);
  float error = -(1 / targetProb);

  outputErrors[hook(2, outputIdx)] = error;
}