//{"cur_roi":22,"in_c":14,"in_c_stride":5,"in_data":2,"in_h":15,"in_h_stride":6,"in_n":13,"in_n_stride":4,"in_rois":3,"in_tmp":23,"in_w":16,"in_w_stride":7,"num_threads":21,"out_c_stride":9,"out_data":0,"out_h":19,"out_h_stride":10,"out_index":1,"out_n_stride":8,"out_w":20,"out_w_stride":11,"roi_num":17,"roi_size":18,"spatial_scale":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Roi_pool(global float* out_data, global float* out_index, global const float* in_data, global const float* in_rois, const int in_n_stride, const int in_c_stride, const int in_h_stride, const int in_w_stride, const int out_n_stride, const int out_c_stride, const int out_h_stride, const int out_w_stride, const float spatial_scale, const int in_n, const int in_c, const int in_h, const int in_w, const int roi_num, const int roi_size, const int out_h, const int out_w, const int num_threads) {
  int tid = get_global_id(0);
  if (tid < num_threads) {
    int n = (tid / out_n_stride);
    int c = (tid / out_c_stride) % in_c;
    int h = (tid / out_h_stride) % out_h;
    int w = (tid / out_w_stride) % out_w;
    global const float* cur_roi = in_rois + n * roi_size;
    int roi_batch_id = cur_roi[hook(22, 0)];
    int roi_start_w = round(cur_roi[hook(22, 1)] * spatial_scale);
    int roi_start_h = round(cur_roi[hook(22, 2)] * spatial_scale);
    int roi_end_w = round(cur_roi[hook(22, 3)] * spatial_scale);
    int roi_end_h = round(cur_roi[hook(22, 4)] * spatial_scale);
    int roi_width = roi_end_w - roi_start_w + 1;
    int roi_height = roi_end_h - roi_start_h + 1;
    float pool_w_rate = (float)roi_width / out_w;
    float pool_h_rate = (float)roi_height / out_h;

    int h_start = (int)(floor((float)(h)*pool_h_rate));
    int w_start = (int)(floor((float)(w)*pool_w_rate));
    int h_end = (int)(ceil((float)(h + 1) * pool_h_rate));
    int w_end = (int)(ceil((float)(w + 1) * pool_w_rate));
    h_start = ((((((h_start + roi_start_h) > (0)) ? (h_start + roi_start_h) : (0))) < (in_h)) ? ((((h_start + roi_start_h) > (0)) ? (h_start + roi_start_h) : (0))) : (in_h));
    h_end = ((((((h_end + roi_start_h) > (0)) ? (h_end + roi_start_h) : (0))) < (in_h)) ? ((((h_end + roi_start_h) > (0)) ? (h_end + roi_start_h) : (0))) : (in_h));
    w_start = ((((((w_start + roi_start_w) > (0)) ? (w_start + roi_start_w) : (0))) < (in_w)) ? ((((w_start + roi_start_w) > (0)) ? (w_start + roi_start_w) : (0))) : (in_w));
    w_end = ((((((w_end + roi_start_w) > (0)) ? (w_end + roi_start_w) : (0))) < (in_w)) ? ((((w_end + roi_start_w) > (0)) ? (w_end + roi_start_w) : (0))) : (in_w));
    bool is_empty = (h_end <= h_start) || (w_end <= w_start);
    float max_val = is_empty ? 0 : -0x1.fffffep127f;
    int max_idx = -1;
    global const float* in_tmp = in_data + roi_batch_id * in_n_stride + c * in_c_stride;
    for (int h_id = h_start; h_id < h_end; ++h_id) {
      for (int w_id = w_start; w_id < w_end; ++w_id) {
        int input_data_index = h_id * in_h_stride + w_id * in_w_stride;
        float data = in_tmp[hook(23, input_data_index)];
        if (data > max_val) {
          max_val = data;
          max_idx = input_data_index;
        }
      }
    }
    out_data[hook(0, tid)] = max_val;
    if (out_index) {
      out_index[hook(1, tid)] = max_idx;
    }
  }
}