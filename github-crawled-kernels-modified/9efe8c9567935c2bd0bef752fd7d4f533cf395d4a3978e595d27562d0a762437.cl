//{"actualOutputs":1,"layerSize":0,"m_rmses":4,"offActualOutputs":5,"offTargetOutputs":6,"patTypes":3,"targetOutputs":2}
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
kernel void rpol_computeRmseFn(int layerSize, global float* actualOutputs, global float* targetOutputs, global char* patTypes, global float* m_rmses) {
  int patIdx = get_global_id(0);
  if (patTypes[hook(3, patIdx)] == 0)
    m_rmses[hook(4, patIdx)] = 0;
  else {
    global float* offActualOutputs = &actualOutputs[hook(1, patIdx * layerSize)];
    global float* offTargetOutputs = &targetOutputs[hook(2, patIdx * layerSize)];

    float sum = 0;
    for (int i = 0; i < layerSize; ++i) {
      float diff = offActualOutputs[hook(5, i)] - offTargetOutputs[hook(6, i)];
      sum += diff * diff;
    }

    m_rmses[hook(4, patIdx)] = sqrt(sum / layerSize);
  }
}