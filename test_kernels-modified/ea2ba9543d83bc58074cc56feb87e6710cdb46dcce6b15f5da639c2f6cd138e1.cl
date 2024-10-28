//{"input":1,"output":2,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef int2 int2;
inline float sigmoid(float f) {
  return 1.0 / (1.0 + exp(-f));
}

inline float sigmoid_derivative(float f) {
  return sigmoid(f) * (1.0 - sigmoid(f));
}

kernel void Sigmoid(unsigned int size, global const float* input, global float* output) {
  unsigned int base = get_local_id(0) + (get_global_id(0) - get_local_id(0)) * 10;
  for (unsigned int i = 0; i < 10; i++) {
    unsigned int index = base + i * get_local_size(0);
    if (index < size) {
      output[hook(2, index)] = sigmoid(input[hook(1, index)]);
    }
  }
}