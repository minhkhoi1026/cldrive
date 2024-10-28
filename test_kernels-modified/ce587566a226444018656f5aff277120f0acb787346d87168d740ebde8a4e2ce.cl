//{"layerSize":0,"m_patTmp":4,"offOutputErrors":6,"offOutputs":5,"outputErrors":2,"outputs":1,"patTypes":3}
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

kernel void sml_calculateErrorOffsetFn(int layerSize, global float* outputs, global float* outputErrors, global char* patTypes, global float* m_patTmp) {
  int patIdx = get_global_id(0);

  if (patTypes[hook(3, patIdx)] == 0)
    m_patTmp[hook(4, patIdx)] = 3.4028235e+038f;
  else {
    global float* offOutputs = &outputs[hook(1, patIdx * layerSize)];
    global float* offOutputErrors = &outputErrors[hook(2, patIdx * layerSize)];

    float offset = 0;
    for (int i = 0; i < layerSize; ++i)
      offset += offOutputs[hook(5, i)] * offOutputErrors[hook(6, i)];

    m_patTmp[hook(4, patIdx)] = offset;
  }
}