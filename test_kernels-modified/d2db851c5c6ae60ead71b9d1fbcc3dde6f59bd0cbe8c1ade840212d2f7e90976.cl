//{"axis_size":7,"dims":8,"input_stride_real":3,"io_data":1,"output_stride_real":4,"shape_valid":5,"softmax_axis":6,"sum_data":2,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void softmax_divid_output_roi_kernel(int total_size, global float* io_data, global const float* sum_data, global const int* input_stride_real, global const int* output_stride_real, global const int* shape_valid, int softmax_axis, int axis_size, int dims) {
  int idx = get_global_id(0);

  if (idx < total_size) {
    int output_real_index = 0;

    for (int i = dims - 1; i >= 0; i--) {
      if (i == softmax_axis) {
        continue;
      } else {
        int x = idx % shape_valid[hook(5, i)];
        output_real_index += x * output_stride_real[hook(4, i)];
        idx = idx / shape_valid[hook(5, i)];
      }
    }

    float sum_data_cur = sum_data[hook(2, idx)];

    for (int i = 0; i < axis_size; ++i) {
      io_data[hook(1, output_real_index)] = io_data[hook(1, output_real_index)] / sum_data_cur;
      output_real_index += output_stride_real[hook(4, softmax_axis)];
    }
  }
}