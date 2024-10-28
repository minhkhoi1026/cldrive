//{"bias":2,"deltas":3,"layerSize":0,"offset":5,"out":4,"patternsCount":1}
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
kernel void ffl_computeBiasWeightUpdateFn(int layerSize, int patternsCount, float bias, global float* deltas, global float* out, int offset) {
  int biasWeightIdx = get_global_id(0);
  global float* offDeltas = deltas + biasWeightIdx;

  float wu = 0;
  for (int i = 0; i < patternsCount; ++i) {
    wu += bias * *offDeltas;
    offDeltas += layerSize;
  }

  out[hook(4, biasWeightIdx + offset)] = wu;
}