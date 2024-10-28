//{"in_data":5,"out_data":0,"out_h":1,"out_w":2,"scale":3,"shift":4,"tile":7,"tile[0]":6,"tile[1]":8,"tile[2]":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_permute_scale_fwd_transpose(global float* out_data, const int out_h, const int out_w, const float scale, const float shift, global const float* in_data) {
  local float tile[3][256];
  int global_idx = get_global_id(0);
  int local_idx = get_local_id(0);

  if (global_idx < out_w) {
    tile[hook(7, 0)][hook(6, local_idx)] = in_data[hook(5, global_idx * out_h + 0)] * scale + shift;
    tile[hook(7, 1)][hook(8, local_idx)] = in_data[hook(5, global_idx * out_h + 1)] * scale + shift;
    tile[hook(7, 2)][hook(9, local_idx)] = in_data[hook(5, global_idx * out_h + 2)] * scale + shift;
  }

  barrier(0x01);

  if (global_idx < out_w) {
    out_data[hook(0, 0 * out_w + global_idx)] = tile[hook(7, 0)][hook(6, local_idx)];
    out_data[hook(0, 1 * out_w + global_idx)] = tile[hook(7, 1)][hook(8, local_idx)];
    out_data[hook(0, 2 * out_w + global_idx)] = tile[hook(7, 2)][hook(9, local_idx)];
  }
}