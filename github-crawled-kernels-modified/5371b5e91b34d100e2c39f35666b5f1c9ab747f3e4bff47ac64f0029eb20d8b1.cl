//{"layerSize":0,"m_patTmp":3,"offOutputs":4,"outputs":1,"patTypes":2}
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
kernel void sml_calculateOffsetFn(int layerSize, global float* outputs, global char* patTypes, global float* m_patTmp) {
  int patIdx = get_global_id(0);
  if (patTypes[hook(2, patIdx)] == 0)
    m_patTmp[hook(3, patIdx)] = 3.4028235e+038f;
  else {
    float maxx = 1.1754944e-038f;
    float minx = 3.4028235e+038f;

    global float* offOutputs = &outputs[hook(1, patIdx * layerSize)];

    for (int i = 0; i < layerSize; ++i) {
      float x = offOutputs[hook(4, i)];
      minx = min(minx, x);
      maxx = max(maxx, x);
    }

    m_patTmp[hook(3, patIdx)] = (float)0.5 * (minx + maxx);
  }
}