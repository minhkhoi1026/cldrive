//{"axis_size":5,"data":6,"in_data":1,"inner_num":3,"out_data":2,"outer_num":4,"total_size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sharemem_softmax_kernel(int total_size, global const float* in_data, global float* out_data, int inner_num, int outer_num, int axis_size) {
  local float data[16384];
  int tid = get_local_id(0);

  int idx = get_global_id(0);

  if (idx < total_size) {
    int idx_inner = idx % inner_num;
    int idx_outer = (idx / inner_num) * axis_size;

    int blocksize = get_local_size(0);

    int real_index = idx_outer * inner_num + idx_inner;
    int loop_idx = real_index;

    for (int i = 0; i < axis_size; ++i) {
      data[hook(6, tid + i * blocksize)] = in_data[hook(1, loop_idx)];
      loop_idx += inner_num;
    }

    float max_data = data[hook(6, tid)];

    for (int i = 1; i < axis_size; ++i) {
      float dt = data[hook(6, tid + i * blocksize)];

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

    loop_idx = real_index;

    for (int i = 0; i < axis_size; ++i) {
      out_data[hook(2, loop_idx)] = data[hook(6, tid + i * blocksize)] / sum;
      loop_idx += inner_num;
    }
  }
}