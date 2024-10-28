//{"img_offset":14,"in_c":11,"in_c_stride":3,"in_data":0,"in_h":12,"in_h_stride":4,"in_n":10,"in_n_stride":2,"in_w":13,"in_w_stride":5,"out_c_stride":7,"out_data":1,"out_h_stride":8,"out_n_stride":6,"out_w_stride":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Pad(global const float* restrict in_data, global float* restrict out_data, int in_n_stride, int in_c_stride, int in_h_stride, int in_w_stride, int out_n_stride, int out_c_stride, int out_h_stride, int out_w_stride, int in_n, int in_c, int in_h, int in_w, int img_offset) {
  out_data += img_offset;
  const int count = in_n * in_c * in_h * in_w;
  const int global_size = get_global_size(0);
  int tid = get_global_id(0);

  for (; tid < count; tid += global_size) {
    int n = (tid / in_n_stride) % in_n;
    int c = (tid / in_c_stride) % in_c;
    int h = (tid / in_h_stride) % in_h;
    int w = (tid / in_w_stride) % in_w;
    int out_offset = n * out_n_stride + c * out_c_stride + h * out_h_stride + w * out_w_stride;
    out_data[hook(1, out_offset)] = in_data[hook(0, tid)];
  }
}