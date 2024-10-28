//{"axis_size":8,"dims":9,"in_data":1,"input_stride_real":4,"min_data":3,"out_data":2,"output_stride_real":5,"shape_valid":6,"softmax_axis":7,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void softmax_max_roi_kernel(int total_size, global const float* in_data, global float* out_data, float min_data, global const int* input_stride_real, global const int* output_stride_real, global const int* shape_valid, int softmax_axis, int axis_size, int dims) {
  int idx = get_global_id(0);

  if (idx < total_size) {
    int input_real_index = 0;

    for (int i = dims - 1; i >= 0; i--) {
      if (i == softmax_axis) {
        continue;
      } else {
        int x = idx % shape_valid[hook(6, i)];
        input_real_index += x * input_stride_real[hook(4, i)];
        idx = idx / shape_valid[hook(6, i)];
      }
    }

    float max_data = min_data;

    for (int i = 0; i < axis_size; ++i) {
      max_data = in_data[hook(1, input_real_index)] > max_data ? in_data[hook(1, input_real_index)] : max_data;
      input_real_index += i * input_stride_real[hook(4, softmax_axis)];
    }

    out_data[hook(2, idx)] = max_data;
  }
}