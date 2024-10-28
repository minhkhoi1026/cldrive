//{"layerSize":0,"n":6,"out":4,"outputs":3,"patTypes":1,"shared":5,"targets":2}
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
kernel void cpol_computeCeFn(int layerSize, global char* patTypes, global float* targets, global float* outputs, global float* out, local float* shared, int n) {
  int index = get_local_id(0);
  shared[hook(5, get_local_id(0))] = 0;
  barrier(0x01);

  while (index < n) {
    float target = targets[hook(2, index)];
    float output = outputs[hook(3, index)];

    int patIdx = index / layerSize;
    if (patTypes[hook(1, index)] != 0) {
      float ftarget = max(1.1754944e-038f, target);
      output = max(1.1754944e-038f, output);
      float div = target * log(ftarget / output);
      shared[hook(5, get_local_id(0))] += div;
    }

    index += get_local_size(0);
  }

  index = get_local_id(0);

  barrier(0x01);
  for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (index < s) {
      shared[hook(5, index)] += shared[hook(5, index + s)];
    }
    barrier(0x01);
  }

  if (get_local_id(0) == 0) {
    out[hook(4, 0)] = shared[hook(5, 0)];
  }
}