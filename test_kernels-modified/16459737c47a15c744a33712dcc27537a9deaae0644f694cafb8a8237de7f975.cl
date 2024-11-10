//{"layerSize":0,"n":5,"out":3,"outputs":1,"shared":4,"targetClasses":2}
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
kernel void mcl_computeCrossEntropyErrorFn(int layerSize, global float* outputs, global int* targetClasses, global float* out, local float* shared, int n) {
  int index = get_local_id(0);
  shared[hook(4, get_local_id(0))] = 0;
  barrier(0x01);
  while (index < n) {
    int targetClass = targetClasses[hook(2, index)];

    if (targetClass != -1) {
      int outputIdx = index * layerSize + targetClass;
      float targetProb = max(1.1754944e-038f, outputs[hook(1, outputIdx)]);
      shared[hook(4, get_local_id(0))] += log(targetProb);
    }
    index += get_local_size(0);
  }
  index = get_local_id(0);

  barrier(0x01);
  for (unsigned int s = get_local_size(0) / 2; s > 0; s >>= 1) {
    if (index < s) {
      shared[hook(4, index)] += shared[hook(4, index + s)];
    }
    barrier(0x01);
  }

  if (get_local_id(0) == 0) {
    out[hook(3, 0)] = shared[hook(4, 0)];
  }
}