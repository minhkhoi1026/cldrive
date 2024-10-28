//{"batch_size":15,"bias_grad":1,"in":2,"in_depth":7,"in_height":5,"in_width":6,"out":3,"out_depth":10,"out_grad":4,"out_height":8,"out_width":9,"padding_height":13,"padding_width":14,"stride_height":11,"stride_width":12,"weight_grad":0}
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

kernel void back_propagate_convolution_relu_gradient_for_weight(global float* weight_grad, global float* bias_grad, const global float* in, const global float* out, const global float* out_grad, const int in_height, const int in_width, const int in_depth, const int out_height, const int out_width, const int out_depth, const int stride_height, const int stride_width, const int padding_height, const int padding_width, const int batch_size)

{
  const int kernel_height = get_global_size(1);
  const int kernel_width = get_global_size(2);
  const int kr = get_global_id(1);
  const int kc = get_global_id(2);

  const int filter = get_global_id(0) / in_depth;
  const int kd = get_global_id(0) % in_depth;

  const int GID = ((filter * kernel_height + kr) * kernel_width + kc) * in_depth + kd;
  float sum_weight_grad = 0, sum_bias_grad = 0;
  int in_offset = kd;
  int out_offset = filter;
  for (int n = 0; n < batch_size; n++, in_offset += in_height * in_width * in_depth, out_offset += out_height * out_width * out_depth)
    for (int rout = 0; rout < out_height; rout++) {
      int rin = rout * stride_height + kr - padding_height;
      if (rin < 0 || rin >= in_height)
        continue;
      for (int cout = 0; cout < out_width; cout++) {
        int cin = cout * stride_width + kc - padding_width;
        if (cin < 0 || cin >= in_width)
          continue;
        int in_index = in_offset + (rin * in_width + cin) * in_depth;
        int out_index = out_offset + (rout * out_width + cout) * out_depth;
        float out_gradient = out_grad[hook(4, out_index)];
        float func_grad = relu_gradient(out[hook(3, out_index)]);
        float data = in[hook(2, in_index)];
        float gradient = func_grad * out_gradient;
        sum_bias_grad += gradient;
        sum_weight_grad += gradient * data;
      }
    }

  weight_grad[hook(0, GID)] += sum_weight_grad;
  if (bias_grad != ((void*)0) && kr == 0 && kc == 0 && kd == 0)
    bias_grad[hook(1, filter)] += sum_bias_grad;
}