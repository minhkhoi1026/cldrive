//{"activation_grad":1,"batch_size":5,"dim_in":4,"dim_out":3,"in":2,"weight_grad":0}
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

kernel void back_propagate_fully_connected_softrelu_gradient_for_weight(global float* weight_grad, const global float* activation_grad, const global float* in, const int dim_out, const int dim_in, const int batch_size) {
  const int n = get_global_id(0);
  const int pos = get_global_id(1);
  const int K = get_global_size(1);

  for (int k = pos; k < dim_in; k += K) {
    float sum_weight_grad = 0;
    for (int j = 0; j < batch_size; j++) {
      const float in_j = in[hook(2, j * dim_in + k)];
      const float out_grad_j = activation_grad[hook(1, j * dim_out + n)];
      sum_weight_grad += in_j * out_grad_j;
    }
    weight_grad[hook(0, k * dim_out + n)] += sum_weight_grad;
  }
}