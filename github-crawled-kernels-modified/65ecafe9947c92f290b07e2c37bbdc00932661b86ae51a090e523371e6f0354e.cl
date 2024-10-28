//{"concat_size":3,"in_data":2,"inner_size":0,"num_concats":1,"offset_concat_axis":5,"out_concat_axis":4,"out_data":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Concat_2d_impl(const int inner_size, const int num_concats, global const float* in_data, const int concat_size, const int out_concat_axis, const int offset_concat_axis, global float* out_data) {
  int idx_inner = get_global_id(0);
  int idx_outer = get_global_id(1);

  if ((idx_inner < inner_size) && (idx_outer < num_concats)) {
    int idx_input = mad24(idx_outer, inner_size, idx_inner);
    int idx_output = (idx_outer * out_concat_axis + offset_concat_axis) * concat_size + idx_inner;
    out_data[hook(6, idx_output)] = in_data[hook(2, idx_input)];
  }
}