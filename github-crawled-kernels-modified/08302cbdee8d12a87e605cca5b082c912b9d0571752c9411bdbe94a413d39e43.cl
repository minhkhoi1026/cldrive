//{"bottom_concat_axis":5,"concat_size":3,"in_data":1,"nthreads":0,"num_concats":2,"offset_concat_axis":6,"out_data":7,"top_concat_axis":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Concat_normal(const int nthreads, global const float* in_data, const int num_concats, const int concat_size, const int top_concat_axis, const int bottom_concat_axis, const int offset_concat_axis, global float* out_data) {
  int index = get_global_id(0);

  if (index < nthreads) {
    const int total_concat_size = concat_size * bottom_concat_axis;
    const int concat_num = index / total_concat_size;
    const int concat_index = index % total_concat_size;
    const int top_index = concat_index + (concat_num * top_concat_axis + offset_concat_axis) * concat_size;
    out_data[hook(7, top_index)] = in_data[hook(1, index)];
  }
}