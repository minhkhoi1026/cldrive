//{"img_offset":14,"in_c_stride":3,"in_data":1,"in_h_stride":4,"in_n_stride":2,"in_w_stride":5,"out_c":11,"out_c_stride":7,"out_data":0,"out_h":12,"out_h_stride":8,"out_n":10,"out_n_stride":6,"out_w":13,"out_w_stride":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Crop(global float* restrict out_data, global const float* restrict in_data, int in_n_stride, int in_c_stride, int in_h_stride, int in_w_stride, int out_n_stride, int out_c_stride, int out_h_stride, int out_w_stride, int out_n, int out_c, int out_h, int out_w, int img_offset) {
  in_data += img_offset;
  int tid = get_global_id(0);
  int global_size = get_global_size(0);
  int count = out_n * out_c * out_h * out_w;

  for (; tid < count; tid += global_size) {
    int n = (tid / out_n_stride) % out_n;
    int c = (tid / out_c_stride) % out_c;
    int h = (tid / out_h_stride) % out_h;
    int w = (tid / out_w_stride) % out_w;

    int in_offset = n * in_n_stride + c * in_c_stride + h * in_h_stride + w * in_w_stride;
    out_data[hook(0, tid)] = in_data[hook(1, in_offset)];
  }
}