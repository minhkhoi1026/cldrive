//{"layerSize":0,"m_patTmp":2,"offOutputs":3,"outputs":1}
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

kernel void sml_sumUpOutputsFn(int layerSize, global float* outputs, global float* m_patTmp) {
  int patIdx = get_global_id(0);

  if (m_patTmp[hook(2, patIdx)] != 3.4028235e+038f) {
    global float* offOutputs = &outputs[hook(1, patIdx * layerSize)];

    float sum = 0;
    for (int i = 0; i < layerSize; ++i)
      sum += offOutputs[hook(3, i)];

    m_patTmp[hook(2, patIdx)] = sum;
  }
}