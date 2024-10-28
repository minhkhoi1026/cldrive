//{"batch_size":9,"beta_grad":2,"deviation":4,"deviation_grad":7,"dim_in":8,"gamma":3,"gamma_grad":1,"in_grad":0,"out_grad":6,"std_dev":5}
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

kernel void back_propagate_batch_normalization_small(global float* in_grad, global float* gamma_grad, global float* beta_grad, const global float* gamma, const global float* deviation, const global float* std_dev, const global float* out_grad, local float* deviation_grad, const int dim_in, const int batch_size) {
  const int GID = get_global_id(0);
  const int k = GID / batch_size;
  const int n = GID % batch_size;

  deviation_grad[hook(7, n)] = out_grad[hook(6, n * dim_in + k)] * gamma[hook(3, k)];
  barrier(0x01);

  float variance_grad = 0;
  float mu_grad = 0, mu_tmp1 = 0, mu_tmp2 = 0;
  float gamma_gradient = 0, beta_gradient = 0;
  for (int i = 0; i < batch_size; i++) {
    variance_grad += deviation_grad[hook(7, i)] * deviation[hook(4, i * dim_in + k)];
    mu_tmp1 += deviation_grad[hook(7, i)];
    mu_tmp2 += deviation[hook(4, i * dim_in + k)];
    gamma_gradient += out_grad[hook(6, i * dim_in + k)] * deviation[hook(4, i * dim_in + k)];
    beta_gradient += out_grad[hook(6, i * dim_in + k)];
  }
  variance_grad *= -0.5f / pow(std_dev[hook(5, k)], 3);
  mu_grad = -mu_tmp1 / std_dev[hook(5, k)] - 2 * variance_grad / batch_size * mu_tmp2;
  in_grad[hook(0, n * dim_in + k)] = deviation_grad[hook(7, n)] / std_dev[hook(5, k)] + 2 * variance_grad * deviation[hook(4, n * dim_in + k)] / batch_size + mu_grad / batch_size;
  gamma_gradient /= std_dev[hook(5, k)];
  gamma_grad[hook(1, k)] = gamma_gradient;
  beta_grad[hook(2, k)] = beta_gradient;
}