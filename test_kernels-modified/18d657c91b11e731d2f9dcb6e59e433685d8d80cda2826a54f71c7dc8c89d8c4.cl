//{"axis_size":9,"dims":10,"in_data":1,"input_stride_real":5,"max_data":3,"out_data":2,"output_stride_real":6,"shape_valid":7,"softmax_axis":8,"sum_data":4,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void softmax_sub_exp_sum_roi_kernel(int total_size, global const float* in_data, global float* out_data, global const float* max_data, global float* sum_data, global const int* input_stride_real, global const int* output_stride_real, global const int* shape_valid, int softmax_axis, int axis_size, int dims) {
  int idx = get_global_id(0);

  if (idx < total_size) {
    int output_real_index = 0;

    for (int i = dims - 1; i >= 0; i--) {
      if (i == softmax_axis) {
        continue;
      } else {
        int x = idx % shape_valid[hook(7, i)];
        output_real_index += x * output_stride_real[hook(6, i)];
        idx = idx / shape_valid[hook(7, i)];
      }
    }

    float max_data_cur = max_data[hook(3, idx)];
    float sum_data_cur = 0;

    for (int i = 0; i < axis_size; ++i) {
      float sub_data = in_data[hook(1, output_real_index)] - max_data_cur;
      sub_data = exp(sub_data);
      sum_data_cur += sub_data;
      out_data[hook(2, output_real_index)] = sub_data;
      output_real_index += output_stride_real[hook(6, softmax_axis)];
    }

    sum_data[hook(4, idx)] = sum_data_cur;
  }
}