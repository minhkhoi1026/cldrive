//{"bottom_data":19,"channel_per_deformable_group":15,"data":1,"data_col":18,"data_offset":2,"data_offset_ptr":20,"dilation_h":13,"dilation_w":14,"height":5,"height_col":16,"im":3,"kernel_h":7,"kernel_w":8,"n":0,"offset_im":4,"pad_h":9,"pad_w":10,"stride_h":11,"stride_w":12,"width":6,"width_col":17}
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
  float v1 = bottom_data[hook(19, h_low * data_width + w_low)];
  float v2 = bottom_data[hook(19, h_low * data_width + w_high)];
  float v3 = bottom_data[hook(19, h_high * data_width + w_low)];
  float v4 = bottom_data[hook(19, h_high * data_width + w_high)];
  float w1 = hh * hw, w2 = hh * lw, w3 = lh * hw, w4 = lh * lw;
  float val = (w1 * v1 + w2 * v2 + w3 * v3 + w4 * v4);
  return val;
}

kernel void deformable_im2col_gpu_kernel(const int n, global const float* data, global const float* data_offset, const int im, const int offset_im, const int height, const int width, const int kernel_h, const int kernel_w, const int pad_h, const int pad_w, const int stride_h, const int stride_w, const int dilation_h, const int dilation_w, const int channel_per_deformable_group, const int height_col, const int width_col, global float* data_col) {
  int global_idx = get_global_id(0);

  if (global_idx < n) {
    const int w_col = global_idx % width_col;
    const int h_col = (global_idx / width_col) % height_col;
    const int c_im = (global_idx / width_col) / height_col;
    const int c_col = c_im * kernel_h * kernel_w;

    const int deformable_group_index = c_im / channel_per_deformable_group;

    const int h_in = h_col * stride_h - pad_h;
    const int w_in = w_col * stride_w - pad_w;

    global float* data_col_ptr = data_col + (c_col * height_col + h_col) * width_col + w_col;
    const global float* data_im_ptr = data + im + (c_im * height + h_in) * width + w_in;
    const global float* data_offset_ptr = data_offset + offset_im + deformable_group_index * 2 * kernel_h * kernel_w * height_col * width_col;

    for (int i = 0; i < kernel_h; ++i) {
      for (int j = 0; j < kernel_w; ++j) {
        const int data_offset_h_ptr = ((2 * (i * kernel_w + j)) * height_col + h_col) * width_col + w_col;

        const int data_offset_w_ptr = ((2 * (i * kernel_w + j) + 1) * height_col + h_col) * width_col + w_col;
        const float offset_h = data_offset_ptr[hook(20, data_offset_h_ptr)];
        const float offset_w = data_offset_ptr[hook(20, data_offset_w_ptr)];
        float val = 0.f;
        const float h_im = h_in + i * dilation_h + offset_h;
        const float w_im = w_in + j * dilation_w + offset_w;

        if (h_im >= 0 && w_im >= 0 && h_im < height && w_im < width) {
          const float map_h = i * dilation_h + offset_h;
          const float map_w = j * dilation_w + offset_w;

          const int cur_height = height - h_in;
          const int cur_width = width - w_in;
          val = deformable_im2col_bilinear(data_im_ptr, width, cur_height, cur_width, map_h, map_w);
        }

        *data_col_ptr = val;
        data_col_ptr += height_col * width_col;
      }
    }
  }
}