//{"dim_hidden":7,"dim_input":6,"hidden":3,"out":1,"sequence_length":5,"timestep":4,"x":2,"x_timestep":0}
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

kernel void feed_forward_LSTM_recurrent(global float* x_timestep, global float* out, const global float* x, const global float* hidden, const int timestep, const int sequence_length, const int dim_input, const int dim_hidden) {
  const int GID = get_global_id(0);
  const int batch = GID / dim_hidden;
  const int j = GID % dim_hidden;
  const int offset = batch * sequence_length + abs(timestep);

  if (timestep >= 0) {
    const int m = batch * dim_input, n = offset * dim_input;
    for (int index = j; index < dim_input; index += dim_hidden)
      x_timestep[hook(0, m + index)] = x[hook(2, n + index)];
  }

  if (out != ((void*)0)) {
    const int k = (offset - 1) * dim_hidden + j;
    out[hook(1, k)] = hidden[hook(3, GID)];
  }
}