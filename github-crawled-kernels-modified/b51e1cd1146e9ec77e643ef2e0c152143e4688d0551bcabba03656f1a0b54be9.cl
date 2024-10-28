//{"batch_size":11,"in":1,"in_depth":4,"in_height":2,"in_width":3,"out":0,"out_index":12,"padding_height":9,"padding_width":10,"pool_height":5,"pool_width":6,"stride_height":7,"stride_width":8}
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

kernel void feed_forward_max_pooling(global float* out, const global float* in, const int in_height, const int in_width, const int in_depth, const int pool_height, const int pool_width, const int stride_height, const int stride_width, const int padding_height, const int padding_width, const int batch_size, global int* out_index) {
  const int out_height = get_global_size(1);
  const int out_width = get_global_size(2);
  const int out_depth = in_depth;
  const int n = get_global_id(0) / out_depth;
  const int rout = get_global_id(1);
  const int cout = get_global_id(2);
  const int filter = get_global_id(0) % out_depth;
  const int offset = ((n * out_height + rout) * out_width + cout) * out_depth + filter;

  float max = -0x1.fffffep127f, max_index;
  for (int pr = 0; pr < pool_height; pr++)
    for (int pc = 0; pc < pool_width; pc++) {
      int rin = rout * stride_height + pr - padding_height;
      int cin = cout * stride_width + pc - padding_width;
      if (rin < 0 || rin >= in_height || cin < 0 || cin >= in_width) {
        if (max < 0) {
          max = 0;
          max_index = -1;
        }
        continue;
      }
      int in_index = ((n * in_height + rin) * in_width + cin) * in_depth + filter;
      if (in[hook(1, in_index)] > max) {
        max = in[hook(1, in_index)];
        max_index = in_index;
      }
    }
  out[hook(0, offset)] = max;
  out_index[hook(12, offset)] = max_index;
}