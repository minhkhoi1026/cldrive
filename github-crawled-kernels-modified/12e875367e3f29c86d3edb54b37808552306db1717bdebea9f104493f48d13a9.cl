//{"col_chw":2,"col_data":15,"col_offset":16,"data_im":0,"data_im_ptr":17,"dilation_h":11,"dilation_w":12,"height":3,"height_col":13,"img_offset":1,"kernel_h":5,"kernel_w":6,"pad_h":7,"pad_w":8,"stride_h":9,"stride_w":10,"width":4,"width_col":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float activation(float in) {
  float output = in;
  return output;
}

inline float4 activation_type4(float4 in

) {
  float4 output = in;
  return output;
}

kernel void im2col(global const float* data_im, const int img_offset, const int col_chw, const int height, const int width, const int kernel_h, const int kernel_w, const int pad_h, const int pad_w, const int stride_h, const int stride_w, const int dilation_h, const int dilation_w, const int height_col, const int width_col, global float* col_data, const int col_offset) {
  int index = get_global_id(0);

  data_im = data_im + img_offset;
  col_data = col_data + col_offset;

  if (index < col_chw) {
    int w_out = index % width_col;
    int h_index = index / width_col;
    int h_out = h_index % height_col;
    int channel_in = h_index / height_col;

    int channel_out = channel_in * kernel_h * kernel_w;
    int h_in = h_out * stride_h - pad_h;
    int w_in = w_out * stride_w - pad_w;

    global float* col_data_ptr = col_data;
    col_data_ptr += (channel_out * height_col + h_out) * width_col + w_out;
    global const float* data_im_ptr = data_im;
    data_im_ptr += (channel_in * height + h_in) * width + w_in;

    int dh = 0;
    for (int i = 0; i < kernel_h; ++i) {
      int dw = 0;
      for (int j = 0; j < kernel_w; ++j) {
        int h = h_in + dh;
        int w = w_in + dw;
        *col_data_ptr = (h >= 0 && w >= 0 && h < height && w < width) ? data_im_ptr[hook(17, dh * width + dw)] : 0;
        col_data_ptr += height_col * width_col;
        dw += dilation_w;
      }
      dh += dilation_h;
    }
  }
}