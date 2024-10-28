//{"bwOutputs":3,"effLayerCLSize":1,"fwOutputs":2,"layerSize":0,"output":4}
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

kernel void ll_resortOutputsFn(int layerSize, int effLayerCLSize, global float* fwOutputs, global float* bwOutputs, global float* output) {
  int outputIdx = get_global_id(0);
  int patIdx = outputIdx / layerSize;
  int valIdx = outputIdx % layerSize;
  int offset = patIdx * effLayerCLSize + valIdx;

  if (valIdx < effLayerCLSize)
    output[hook(4, outputIdx)] = fwOutputs[hook(2, offset)];
  else
    output[hook(4, outputIdx)] = bwOutputs[hook(3, offset - effLayerCLSize)];
}