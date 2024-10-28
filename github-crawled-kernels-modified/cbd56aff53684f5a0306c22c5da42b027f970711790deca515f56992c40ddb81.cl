//{"in_data":6,"out_data":0,"out_h":1,"out_w":2,"power":5,"scale":3,"shift":4,"tile":8,"tile[0]":7,"tile[1]":9,"tile[2]":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_permute_power_fwd_transpose(global float* out_data, const int out_h, const int out_w, const float scale, const float shift, const float power, global const float* in_data) {
  local float tile[3][256];
  int global_idx = get_global_id(0);
  int local_idx = get_local_id(0);

  if (global_idx < out_w) {
    tile[hook(8, 0)][hook(7, local_idx)] = pow(in_data[hook(6, global_idx * out_h + 0)] * scale + shift, power);
    tile[hook(8, 1)][hook(9, local_idx)] = pow(in_data[hook(6, global_idx * out_h + 1)] * scale + shift, power);
    tile[hook(8, 2)][hook(10, local_idx)] = pow(in_data[hook(6, global_idx * out_h + 2)] * scale + shift, power);
  }

  barrier(0x01);

  if (global_idx < out_w) {
    out_data[hook(0, 0 * out_w + global_idx)] = tile[hook(8, 0)][hook(7, local_idx)];
    out_data[hook(0, 1 * out_w + global_idx)] = tile[hook(8, 1)][hook(9, local_idx)];
    out_data[hook(0, 2 * out_w + global_idx)] = tile[hook(8, 2)][hook(10, local_idx)];
  }
}