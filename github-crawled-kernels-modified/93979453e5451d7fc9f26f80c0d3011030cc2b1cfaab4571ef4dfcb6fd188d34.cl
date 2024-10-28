//{"c":2,"h":3,"in_data":7,"in_stride":6,"n":1,"out_data":0,"out_stride":5,"tile":9,"tile[0]":8,"tile[1]":10,"tile[2]":11,"w":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_permute_fwd_transpose_stride(global float* out_data, const int n, const int c, const int h, const int w, global const int* out_stride, global const int* in_stride, global const float* in_data) {
  int global_idx = get_global_id(0);
  int local_idx = get_local_id(0);
  local float tile[3][256];
  int out_w_id = global_idx % w;
  int out_h_id = (global_idx / w) % h;
  int out_n_id = global_idx / (h * w);
  int out_offset = out_n_id * out_stride[hook(5, 0)] + out_h_id * out_stride[hook(5, 2)] + out_w_id * out_stride[hook(5, 3)];
  int in_offset = out_n_id * in_stride[hook(6, 0)] + out_h_id * in_stride[hook(6, 1)] + out_w_id * in_stride[hook(6, 2)];

  if (global_idx < n * h * w) {
    tile[hook(9, 0)][hook(8, local_idx)] = in_data[hook(7, in_offset)];
    tile[hook(9, 1)][hook(10, local_idx)] = in_data[hook(7, in_offset + 1)];
    tile[hook(9, 2)][hook(11, local_idx)] = in_data[hook(7, in_offset + 2)];
  }

  barrier(0x01);

  if (global_idx < n * h * w) {
    out_data[hook(0, out_offset + out_stride[1hook(5, 1) * 0)] = tile[hook(9, 0)][hook(8, local_idx)];
    out_data[hook(0, out_offset + out_stride[1hook(5, 1) * 1)] = tile[hook(9, 1)][hook(10, local_idx)];
    out_data[hook(0, out_offset + out_stride[1hook(5, 1) * 2)] = tile[hook(9, 2)][hook(11, local_idx)];
  }
}