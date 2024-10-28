//{"actualoutput":3,"erroroutputs":2,"patTypes":0,"targets":1}
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
kernel void bcl_computeOutputErrorFn(global char* patTypes, global float* targets, global float* erroroutputs, global float* actualoutput) {
  int outputIdx = get_global_id(0);

  if (patTypes[hook(0, outputIdx)] != 0) {
    float target = targets[hook(1, outputIdx)];
    float output = actualoutput[hook(3, outputIdx)];

    float act = max(output, 1.1754944e-038f);
    float targetProb = (target > 0 ? act : 1 - act);
    float error = (target > 0 ? -(1 / targetProb) : (1 / targetProb));

    erroroutputs[hook(2, outputIdx)] = error;
  }
}