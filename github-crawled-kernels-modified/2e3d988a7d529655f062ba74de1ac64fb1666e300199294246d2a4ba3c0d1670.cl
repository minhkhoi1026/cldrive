//{"c":2,"h":3,"in_data":7,"in_stride":6,"n":1,"out_data":0,"out_stride":5,"tile":9,"tile[local_idx]":8,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_nchw_to_nhwc(global float* out_data, const int n, const int c, const int h, const int w, global const int* out_stride, global const int* in_stride, global const float* in_data) {
  local float tile[16][16];
  int global_idx = get_global_id(0);
  int global_idy = get_global_id(1);
  int local_idx = get_local_id(0);
  int local_idy = get_local_id(1);
  int w_id = global_idy % w;
  int h_id = global_idy / w;
  int c_id = global_idx % c;
  int n_id = global_idx / c;
  int in_offset = n_id * in_stride[hook(6, 0)] + c_id * in_stride[hook(6, 1)] + h_id * in_stride[hook(6, 2)] + w_id * in_stride[hook(6, 3)];
  int out_offset = n_id * out_stride[hook(5, 0)] + h_id * out_stride[hook(5, 1)] + w_id * out_stride[hook(5, 2)] + c_id * out_stride[hook(5, 3)];

  if (global_idx < n * c && global_idy < h * w) {
    tile[hook(9, local_idx)][hook(8, local_idy)] = in_data[hook(7, in_offset)];
  }

  barrier(0x01);

  if (global_idx < n * c && global_idy < h * w) {
    out_data[hook(0, out_offset)] = tile[hook(9, local_idx)][hook(8, local_idy)];
  }
}