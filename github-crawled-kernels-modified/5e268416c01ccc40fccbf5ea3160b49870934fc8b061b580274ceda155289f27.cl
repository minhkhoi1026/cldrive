//{"in_c":16,"in_c_stride":4,"in_data":2,"in_h":7,"in_h_stride":5,"in_n":15,"in_n_stride":3,"in_w":8,"in_w_stride":6,"num_threads":23,"out_c_stride":10,"out_data":0,"out_h":13,"out_h_stride":11,"out_index":1,"out_n_stride":9,"out_w":14,"out_w_stride":12,"pad_h":17,"pad_w":18,"stride_h":19,"stride_w":20,"window_h":21,"window_w":22}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Pooling_with_index(global float* out_data, global float* out_index, global const float* in_data, const int in_n_stride, const int in_c_stride, const int in_h_stride, const int in_w_stride, const int in_h, const int in_w, const int out_n_stride, const int out_c_stride, const int out_h_stride, const int out_w_stride, const int out_h, const int out_w, const int in_n, const int in_c, const int pad_h, const int pad_w, const int stride_h, const int stride_w, const int window_h, const int window_w, const int num_threads) {
  int tid = get_global_id(0);
  if (tid < num_threads) {
    int n = (tid / out_n_stride) % in_n;
    int c = (tid / out_c_stride) % in_c;
    int h = (tid / out_h_stride) % out_h;
    int w = (tid / out_w_stride) % out_w;
    float max_data = -0x1.fffffep127f;
    float max_index = 0;
    int start_h = h * stride_h - pad_h;
    int end_h = start_h + window_h;
    start_h = start_h < 0 ? 0 : start_h;
    end_h = end_h > in_h ? in_h : end_h;

    int start_w = w * stride_w - pad_w;
    int end_w = start_w + window_w;
    start_w = start_w < 0 ? 0 : start_w;
    end_w = end_w > in_w ? in_w : end_w;

    int in_offset = n * in_n_stride + c * in_c_stride;
    for (int i = start_h; i < end_h; i++) {
      for (int j = start_w; j < end_w; j++) {
        float data = in_data[hook(2, in_offset + i * in_h_stride + j * in_w_stride)];
        if (data > max_data) {
          max_data = data;
          ;
          max_index = i * in_w + j;
        }
      }
    }
    out_data[hook(0, tid)] = max_data;
    out_index[hook(1, tid)] = max_index;
  }
}