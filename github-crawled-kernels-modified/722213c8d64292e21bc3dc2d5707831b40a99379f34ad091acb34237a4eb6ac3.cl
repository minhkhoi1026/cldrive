//{"t0":0,"t1":1,"typeAF":2}
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
kernel void ffl_computeDeltaFn(global float* t0, global float* t1, int typeAF) {
  int index = get_global_id(0);
  float d;
  if (typeAF == 0)
    d = Tanh_deriv(t1[hook(1, index)]);
  else if (typeAF == 1)
    d = Logistic_deriv(t1[hook(1, index)]);
  else
    d = Identity_deriv(t1[hook(1, index)]);

  t0[hook(0, index)] = d * t0[hook(0, index)];
}