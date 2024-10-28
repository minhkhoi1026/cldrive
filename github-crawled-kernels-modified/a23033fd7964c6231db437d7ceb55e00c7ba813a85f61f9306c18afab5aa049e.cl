//{"data_col":9,"data_im":1,"data_im_ptr":10,"height":2,"height_col":7,"ksize":4,"n":0,"pad":5,"stride":6,"width":3,"width_col":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef enum { LOGISTIC, RELU, RELIE, LINEAR, RAMP, TANH, PLSE, LEAKY, ELU, LOGGY, STAIR, HARDTAN, LHTAN } ACTIVATION;

kernel void image2columarray3x3(int n, global float* data_im, int height, int width, int ksize, const int pad, int stride, int height_col, int width_col, global float* data_col) {
  int index = get_global_id(0);
  int stepSize = get_local_size(0) * get_num_groups(0);
  int w_out, h_index, h_out, channel_in, channel_out, h_in, w_in, i, j, h, w;

  for (; index < n; index += stepSize) {
    w_out = index % width_col;
    h_index = index / width_col;
    h_out = h_index % height_col;
    channel_in = h_index / height_col;
    channel_out = channel_in * ksize * ksize;
    h_in = h_out * stride - pad;
    w_in = w_out * stride - pad;

    global float* data_col_ptr = data_col;
    data_col_ptr += (channel_out * height_col + h_out) * width_col + w_out;

    const global float* data_im_ptr = data_im;
    data_im_ptr += (channel_in * height + h_in) * width + w_in;

    for (i = 0; i < 3; ++i) {
      for (j = 0; j < 3; ++j) {
        h = h_in + i;
        w = w_in + j;

        *data_col_ptr = (h >= 0 && w >= 0 && h < height && w < width) ? data_im_ptr[hook(10, i * width + j)] : 0;
        data_col_ptr += height_col * width_col;
      }
    }
  }
}