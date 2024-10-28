//{"bias":5,"dst":7,"flag_bias":9,"flag_scale":8,"inner_size":1,"mean":2,"scale":4,"src":6,"std":3,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalize_with_scale_bias(int total_size, int inner_size, global const float* mean, global const float* std, global const float* scale, global const float* bias, global const float* src, global float* dst, int flag_scale, int flag_bias) {
  int idx = get_global_id(0);

  if (idx < total_size) {
    int outer_idx = (idx / inner_size);
    int inner_idx = (idx % inner_size);

    if (flag_scale) {
      if (flag_bias) {
        dst[hook(7, idx)] = (src[hook(6, idx)] - mean[hook(2, outer_idx)]) * std[hook(3, outer_idx)] * scale[hook(4, inner_idx)] + bias[hook(5, inner_idx)];
      } else {
        dst[hook(7, idx)] = (src[hook(6, idx)] - mean[hook(2, outer_idx)]) * std[hook(3, outer_idx)] * scale[hook(4, inner_idx)];
      }
    } else {
      if (flag_bias) {
        dst[hook(7, idx)] = (src[hook(6, idx)] - mean[hook(2, outer_idx)]) * std[hook(3, outer_idx)] + bias[hook(5, inner_idx)];
      } else {
        dst[hook(7, idx)] = (src[hook(6, idx)] - mean[hook(2, outer_idx)]) * std[hook(3, outer_idx)];
      }
    }
  }
}