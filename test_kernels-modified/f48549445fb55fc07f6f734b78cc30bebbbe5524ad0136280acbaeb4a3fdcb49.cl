//{"layerSize":0,"offsets":1,"outputs":2}
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
float safeExp(float x) {
  if (x <= -1e30)
    return 0;
  else if (x >= 88.722839f)
    return 3.4028235e+038f;
  else
    return exp(x);
}

kernel void sml_calculateExpFn(int layerSize, global float* offsets, global float* outputs) {
  int outputId = get_global_id(0);
  float output = outputs[hook(2, outputId)];

  int patIdx = outputId / layerSize;

  float offset = offsets[hook(1, patIdx)];
  if (offset != 3.4028235e+038f) {
    float x = safeExp(output - offset);

    outputs[hook(2, outputId)] = x;
  }
}