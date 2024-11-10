//{"c":2,"h":3,"in_data":15,"in_stride_c":10,"in_stride_h":11,"in_stride_n":9,"in_stride_w":12,"n":1,"out_data":0,"out_stride_c":6,"out_stride_h":7,"out_stride_n":5,"out_stride_w":8,"scale":13,"shift":14,"tile":17,"tile[0]":16,"tile[1]":18,"tile[2]":19,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_nhwc_to_nchw_scale(global float* out_data, const int n, const int c, const int h, const int w, const int out_stride_n, const int out_stride_c, const int out_stride_h, const int out_stride_w, const int in_stride_n, const int in_stride_c, const int in_stride_h, const int in_stride_w, const float scale, const float shift, global const float* in_data) {
  local float tile[3][256];
  int global_idx = get_global_id(0);
  int local_idx = get_local_id(0);
  int w_id = global_idx % w;
  int h_id = (global_idx / w) % h;
  int n_id = (global_idx / (h * w)) % n;
  int in_offset = n_id * in_stride_n + h_id * in_stride_h + w_id * in_stride_w;
  int out_offset = n_id * out_stride_n + h_id * out_stride_h + w_id * out_stride_w;

  if (global_idx < n * h * w) {
    tile[hook(17, 0)][hook(16, local_idx)] = in_data[hook(15, in_offset + 0)] * scale + shift;
    tile[hook(17, 1)][hook(18, local_idx)] = in_data[hook(15, in_offset + 1)] * scale + shift;
    tile[hook(17, 2)][hook(19, local_idx)] = in_data[hook(15, in_offset + 2)] * scale + shift;
  }

  barrier(0x01);

  if (global_idx < n * h * w) {
    out_data[hook(0, 0 * out_stride_c + out_offset)] = tile[hook(17, 0)][hook(16, local_idx)];
    out_data[hook(0, 1 * out_stride_c + out_offset)] = tile[hook(17, 1)][hook(18, local_idx)];
    out_data[hook(0, 2 * out_stride_c + out_offset)] = tile[hook(17, 2)][hook(19, local_idx)];
  }
}