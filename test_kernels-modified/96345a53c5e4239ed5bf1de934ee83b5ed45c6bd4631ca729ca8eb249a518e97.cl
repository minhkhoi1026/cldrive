//{"batch_size":11,"beta":7,"deviation":1,"dim_in":10,"epsilon":8,"gamma":6,"in":5,"momentum":9,"moving_mean":3,"moving_variance":4,"out":0,"std_dev":2}
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

kernel void feed_forward_batch_normalization_small(global float* out, global float* deviation, global float* std_dev, global float* moving_mean, global float* moving_variance, const global float* in, const global float* gamma, const global float* beta, const float epsilon, const float momentum, const int dim_in, const int batch_size) {
  const int k = get_global_id(0);

  float mean = 0;
  for (int i = 0; i < batch_size; i++)
    mean += in[hook(5, i * dim_in + k)];
  mean /= batch_size;
  moving_mean[hook(3, k)] = moving_mean[hook(3, k)] * (1.0f - momentum) + mean * momentum;

  float sigma2 = 0;
  for (int i = 0; i < batch_size; i++) {
    const float delta = in[hook(5, i * dim_in + k)] - mean;
    deviation[hook(1, i * dim_in + k)] = delta;
    sigma2 += delta * delta;
  }
  sigma2 = sigma2 / batch_size;
  moving_variance[hook(4, k)] = moving_variance[hook(4, k)] * (1.0f - momentum) + sigma2 * momentum;
  sigma2 = sqrt(sigma2 + epsilon);
  if (std_dev != ((void*)0))
    std_dev[hook(2, k)] = sigma2;

  for (int i = 0; i < batch_size; i++)
    out[hook(0, i * dim_in + k)] = gamma[hook(6, k)] / sigma2 * deviation[hook(1, i * dim_in + k)] + beta[hook(7, k)];
}