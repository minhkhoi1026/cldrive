//{"in_data":3,"out_data":0,"out_h":1,"out_w":2,"tile":5,"tile[local_idx]":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_transpose(global float* out_data, const int out_h, const int out_w, global const float* in_data) {
  local float tile[16][16];
  int global_idx = get_global_id(0);
  int global_idy = get_global_id(1);
  int local_idx = get_local_id(0);
  int local_idy = get_local_id(1);

  if (global_idx < out_h && global_idy < out_w) {
    tile[hook(5, local_idx)][hook(4, local_idy)] = in_data[hook(3, global_idx + global_idy * out_h)];
  }

  barrier(0x01);

  if (global_idx < out_h && global_idy < out_w) {
    out_data[hook(0, global_idx * out_w + global_idy)] = tile[hook(5, local_idx)][hook(4, local_idy)];
  }
}