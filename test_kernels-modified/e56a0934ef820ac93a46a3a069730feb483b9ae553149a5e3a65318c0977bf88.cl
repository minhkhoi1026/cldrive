//{"axis_size":5,"inner_num":3,"io_data":1,"outer_num":4,"sum_data":2,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void softmax_divid_output_kernel(int total_size, global float* io_data, global const float* sum_data, int inner_num, int outer_num, int axis_size) {
  int idx = get_global_id(0);

  if (idx < total_size) {
    int idx_inner = idx % inner_num;
    int idx_outer = (idx / inner_num) * axis_size;
    float sum_data_cur = sum_data[hook(2, idx)];
    int real_index = idx_outer * inner_num + idx_inner;

    for (int i = 0; i < axis_size; ++i) {
      io_data[hook(1, real_index)] = io_data[hook(1, real_index)] / sum_data_cur;
      real_index += inner_num;
    }
  }
}