//{"batch_size":6,"dim_in":5,"dim_out":4,"in_grad":0,"out":2,"out_grad":3,"weight":1}
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

kernel void back_propagate_fully_connected_softrelu_gradient_for_data(global float* in_grad, const global float* weight, const global float* out, const global float* out_grad, const int dim_out, const int dim_in, const int batch_size) {
  const int GID = get_global_id(0);
  const int k = GID % dim_in;
  const int n = GID / dim_in;

  float sum_in_grad = 0;
  for (int j = 0; j < dim_out; j++) {
    const float weight_j = weight[hook(1, k * dim_out + j)];
    const float out_grad_j = softrelu_gradient(out[hook(2, n * dim_out + j)]) * out_grad[hook(3, n * dim_out + j)];
    sum_in_grad += weight_j * out_grad_j;
  }
  in_grad[hook(0, n * dim_in + k)] = sum_in_grad;
}