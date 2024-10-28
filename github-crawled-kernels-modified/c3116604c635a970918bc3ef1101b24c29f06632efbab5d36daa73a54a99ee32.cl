//{"activation_grad":0,"batch_size":6,"bias_grad":1,"dim_in":5,"dim_out":4,"out":2,"out_grad":3}
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

kernel void back_propagate_fully_connected_softrelu_gradient_for_bias(global float* activation_grad, global float* bias_grad, const global float* out, const global float* out_grad, const int dim_out, const int dim_in, const int batch_size) {
  const int n = get_global_id(0);

  float sum_bias_grad = 0;
  for (int j = 0; j < batch_size; j++) {
    const float out_grad_j = softrelu_gradient(out[hook(2, j * dim_out + n)]) * out_grad[hook(3, j * dim_out + n)];
    activation_grad[hook(0, j * dim_out + n)] = out_grad_j;
    sum_bias_grad += out_grad_j;
  }
  if (bias_grad != ((void*)0))
    bias_grad[hook(1, n)] += sum_bias_grad;
}