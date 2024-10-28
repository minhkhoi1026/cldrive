//{"learning_rate":2,"momentum":4,"params":0,"params_grad":1,"velocity":5,"weight_decay":3}
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

kernel void update_parameters_by_stochastic_gradient_descent_with_momentum(global float* params, global float* params_grad, float learning_rate, float weight_decay, float momentum, global float* velocity) {
  const int GID = get_global_id(0);
  const float gradient = params_grad[hook(1, GID)] + weight_decay * params[hook(0, GID)];
  const float vt = momentum * velocity[hook(5, GID)] + gradient;
  params[hook(0, GID)] -= learning_rate * vt;
  velocity[hook(5, GID)] = vt;
  params_grad[hook(1, GID)] = 0;
}