//{"bias":3,"dim_hidden":5,"dim_in":6,"in":1,"out":0,"tmp":4,"weight":2}
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

kernel void feed_forward_fully_connected_sigmoid(global float* out, const global float* in, const global float* weight, const global float* bias, local float* tmp, const int dim_hidden, const int dim_in) {
  const int GID = get_global_id(0);
  const int n = GID / dim_hidden;
  const int hidden = GID % dim_hidden;
  const int in_offset = n * dim_in;
  float z = bias != ((void*)0) ? bias[hook(3, hidden)] : 0;

  for (int i = 0; i < dim_in; i++)
    z += weight[hook(2, dim_hidden * i + hidden)] * in[hook(1, in_offset + i)];
  out[hook(0, GID)] = sigmoid(z);
}