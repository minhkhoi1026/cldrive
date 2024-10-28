//{"axis_size":6,"in_data":1,"inner_num":4,"min_data":3,"out_data":2,"outer_num":5,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void softmax_max_kernel(int total_size, global const float* in_data, global float* out_data, float min_data, int inner_num, int outer_num, int axis_size) {
  int idx = get_global_id(0);

  if (idx < total_size) {
    int idx_inner = idx % inner_num;
    int idx_outer = (idx / inner_num) * axis_size;
    int real_index = idx_outer * inner_num + idx_inner;

    float max_data = min_data;

    for (int i = 0; i < axis_size; ++i) {
      max_data = in_data[hook(1, real_index)] > max_data ? in_data[hook(1, real_index)] : max_data;
      real_index += inner_num;
    }

    out_data[hook(2, idx)] = max_data;
  }
}