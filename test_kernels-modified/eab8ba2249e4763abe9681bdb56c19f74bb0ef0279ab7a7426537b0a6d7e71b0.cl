//{"dim_in":4,"input":1,"out":0,"tmp":3,"vector_length":5,"vector_weight":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float sigmoid(float z) {
  return 1.0f / (1.0f + exp(-z));
}
inline float sigmoid_gradient(float y) {
  return y * (1.0f - y);
}

inline float relu(float z) {
  return z > 0 ? z : 0;
}
inline float relu_gradient(float y) {
  return y > 0 ? 1 : 0;
}

inline float tanh_gradient(float y) {
  return 1.0f - y * y;
}

inline float softrelu(float z) {
  return log(1.0f + exp(z));
}
inline float softrelu_gradient(float y) {
  return 1.0f - exp(-y);
}

inline float leakyrelu(float z) {
  return z > 0 ? z : 0.25f * z;
}
inline float leakyrelu_gradient(float y) {
  return y > 0 ? 1 : 0.25f;
}

inline float linear_regression(float y, float label) {
  float delta = y - label;
  return delta * delta;
}
inline float linear_regression_gradient(float y, float label) {
  return y - label;
}

inline float negative_log_likelihood_gradient(float y, bool i_equal_j) {
  return i_equal_j ? y - 1.0f : y;
}

kernel void feed_forward_embedding(global float* out, const global float* input, const global float* vector_weight, local float* tmp, const int dim_in, const int vector_length) {
  const int GID = get_global_id(0);
  const int parallel = get_local_size(0);
  const int weight_offset = GID / parallel;

  for (int index = GID % parallel; index < dim_in; index += parallel)
    out[hook(0, index * vector_length + weight_offset)] = vector_weight[hook(2, ((int)input[ihook(1, index)) * vector_length + weight_offset)];
}