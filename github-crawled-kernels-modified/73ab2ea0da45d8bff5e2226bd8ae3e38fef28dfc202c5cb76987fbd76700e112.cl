//{"axis_size":7,"in_data":1,"inner_num":5,"max_data":3,"out_data":2,"outer_num":6,"sum_data":4,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void softmax_sub_exp_sum_kernel(int total_size, global const float* in_data, global float* out_data, global const float* max_data, global float* sum_data, int inner_num, int outer_num, int axis_size) {
  int idx = get_global_id(0);

  if (idx < total_size) {
    int idx_inner = idx % inner_num;
    int idx_outer = (idx / inner_num) * axis_size;

    float max_data_cur = max_data[hook(3, idx)];
    float sum_data_cur = 0;
    int real_index = idx_outer * inner_num + idx_inner;

    for (int i = 0; i < axis_size; ++i) {
      float sub_data = in_data[hook(1, real_index)] - max_data_cur;
      sub_data = exp(sub_data);
      sum_data_cur += sub_data;
      out_data[hook(2, real_index)] = sub_data;
      real_index += inner_num;
    }

    sum_data[hook(4, idx)] = sum_data_cur;
  }
}