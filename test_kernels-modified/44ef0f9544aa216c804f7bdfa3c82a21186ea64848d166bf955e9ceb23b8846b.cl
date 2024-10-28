//{"axis_size":7,"data":9,"dims":8,"in_data":1,"input_stride_real":3,"out_data":2,"output_stride_real":4,"shape_valid":5,"softmax_axis":6,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sharemem_softmax_roi_kernel(int total_size, global const float* in_data, global float* out_data, global const int* input_stride_real, global const int* output_stride_real, global const int* shape_valid, int softmax_axis, int axis_size, int dims) {
  local float data[16384];
  int tid = get_local_id(0);

  int idx1 = get_global_id(0);
  int idx = idx1;

  if (idx < total_size) {
    int blocksize = get_local_size(0);

    int input_real_index = 0;
    int output_real_index = 0;

    for (int i = dims - 1; i >= 0; i--) {
      if (i == softmax_axis) {
        continue;
      } else {
        int x = idx % shape_valid[hook(5, i)];
        input_real_index += x * input_stride_real[hook(3, i)];
        output_real_index += x * output_stride_real[hook(4, i)];
        idx = idx / shape_valid[hook(5, i)];
      }
    }

    for (int i = 0; i < axis_size; ++i) {
      data[hook(9, tid + i * blocksize)] = in_data[hook(1, input_real_index)];
      input_real_index += input_stride_real[hook(3, softmax_axis)];
    }

    float max_data = data[hook(9, tid)];

    for (int i = 1; i < axis_size; ++i) {
      float dt = data[hook(9, tid + i * blocksize)];

      if (max_data < dt) {
        max_data = dt;
      }
    }

    float sum = 0;

    for (int i = 0; i < axis_size; ++i) {
      local float* dt = data + tid + i * blocksize;
      *dt = exp(*dt - max_data);
      sum += *dt;
    }

    for (int i = 0; i < axis_size; ++i) {
      out_data[hook(2, output_real_index)] = data[hook(9, tid + i * blocksize)] / sum;
      output_real_index += output_stride_real[hook(4, softmax_axis)];
    }
  }
}