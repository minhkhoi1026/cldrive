//{"in_data":3,"out_data":0,"out_h":1,"out_w":2,"tile":5,"tile[0]":4,"tile[1]":6,"tile[2]":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_permute_fwd_transpose(global float* out_data, const int out_h, const int out_w, global const float* in_data) {
  int global_idx = get_global_id(0);
  int local_idx = get_local_id(0);
  local float tile[3][256];

  if (global_idx < out_w) {
    int offset = global_idx * out_h;
    tile[hook(5, 0)][hook(4, local_idx)] = in_data[hook(3, offset)];
    tile[hook(5, 1)][hook(6, local_idx)] = in_data[hook(3, offset + 1)];
    tile[hook(5, 2)][hook(7, local_idx)] = in_data[hook(3, offset + 2)];
  }

  barrier(0x01);

  if (global_idx < out_w) {
    out_data[hook(0, 0 * out_w + global_idx)] = tile[hook(5, 0)][hook(4, local_idx)];
    out_data[hook(0, 1 * out_w + global_idx)] = tile[hook(5, 1)][hook(6, local_idx)];
    out_data[hook(0, 2 * out_w + global_idx)] = tile[hook(5, 2)][hook(7, local_idx)];
  }
}