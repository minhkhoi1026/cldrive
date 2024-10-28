//{"batch_size":8,"beta":5,"dim_in":7,"epsilon":6,"gamma":4,"in":3,"moving_mean":1,"moving_variance":2,"out":0}
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

kernel void feed_forward_batch_normalization_for_inference(global float* out, const global float* moving_mean, const global float* moving_variance, const global float* in, const global float* gamma, const global float* beta, const float epsilon, const int dim_in, const int batch_size) {
  const int GID = get_global_id(0);
  const int k = GID / batch_size;
  const int n = GID % batch_size;

  out[hook(0, n * dim_in + k)] = gamma[hook(4, k)] / sqrt(moving_variance[hook(2, k)] + epsilon) * (in[hook(3, n * dim_in + k)] - moving_mean[hook(1, k)]) + beta[hook(5, k)];
}