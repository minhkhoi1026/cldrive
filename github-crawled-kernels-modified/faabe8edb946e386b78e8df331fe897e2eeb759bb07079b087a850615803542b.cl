//{"bias":10,"bottom_data":11,"count":1,"in_c":3,"in_c_stride":7,"in_h":4,"in_h_stride":8,"in_n":2,"in_n_stride":6,"in_w":5,"in_w_stride":9,"out_data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float deformable_im2col_bilinear(const global float* bottom_data, const int data_width, const int height, const int width, float h, float w) {
  int h_low = floor(h);
  int w_low = floor(w);
  int h_high;
  int w_high;

  if (h_low >= height - 1) {
    h_high = h_low = height - 1;
    h = (float)h_low;
  } else {
    h_high = h_low + 1;
  }

  if (w_low >= width - 1) {
    w_high = w_low = width - 1;
    w = (float)w_low;
  } else {
    w_high = w_low + 1;
  }

  float lh = h - h_low;
  float lw = w - w_low;
  float hh = 1 - lh, hw = 1 - lw;
  float v1 = bottom_data[hook(11, h_low * data_width + w_low)];
  float v2 = bottom_data[hook(11, h_low * data_width + w_high)];
  float v3 = bottom_data[hook(11, h_high * data_width + w_low)];
  float v4 = bottom_data[hook(11, h_high * data_width + w_high)];
  float w1 = hh * hw, w2 = hh * lw, w3 = lh * hw, w4 = lh * lw;
  float val = (w1 * v1 + w2 * v2 + w3 * v3 + w4 * v4);
  return val;
}

kernel void gpu_add_bias(global float* out_data, const int count, int in_n, int in_c, int in_h, int in_w, int in_n_stride, int in_c_stride, int in_h_stride, int in_w_stride, global const float* bias) {
  int global_idx = get_global_id(0);

  if (global_idx < count) {
    int read_w = global_idx % in_w;
    int read_h = (global_idx / (in_w)) % in_h;
    int read_c = (global_idx / (in_h * in_w)) % in_c;
    int read_n = (global_idx / (in_c * in_h * in_w)) % in_n;

    int in_idx = read_n * in_n_stride + read_c * in_c_stride + read_h * in_h_stride + read_w * in_w_stride;

    float in_var = out_data[hook(0, in_idx)];
    float in_bias = bias[hook(10, read_c)];
    out_data[hook(0, in_idx)] = in_var + in_bias;
  }
}