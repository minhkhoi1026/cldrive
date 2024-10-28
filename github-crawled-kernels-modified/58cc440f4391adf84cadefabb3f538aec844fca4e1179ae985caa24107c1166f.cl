//{"NUM_WORK_ITEMS":2,"central_moments":4,"data":0,"group_result":1,"local_result":3,"workgroups_left":5,"x_":6,"y_":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void moments(global uchar8* data, global float* group_result, int NUM_WORK_ITEMS, local float* local_result, global double* central_moments, global int* workgroups_left, float x_, float y_) {
  const int KERNEL_SIZE = 8;
  const int row = get_group_id(0);
  const int initial_col = get_local_id(0) * KERNEL_SIZE;

  const int data_offset = get_global_id(0);
  uchar8 input_data = data[hook(0, data_offset)];

  float momentX0 = input_data.s0 + input_data.s1 + input_data.s2 + input_data.s3 + input_data.s4 + input_data.s5 + input_data.s6 + input_data.s7;

  float momentX1 = input_data.s0 * (1 + initial_col - y_) + input_data.s1 * (2 + initial_col - y_) + input_data.s2 * (3 + initial_col - y_) + input_data.s3 * (4 + initial_col - y_) + input_data.s4 * (5 + initial_col - y_) + input_data.s5 * (6 + initial_col - y_) + input_data.s6 * (7 + initial_col - y_) + input_data.s7 * (8 + initial_col - y_);

  float momentX2 = input_data.s0 * (1 + initial_col - y_) * (1 + initial_col - y_) + input_data.s1 * (2 + initial_col - y_) * (2 + initial_col - y_) + input_data.s2 * (3 + initial_col - y_) * (3 + initial_col - y_) + input_data.s3 * (4 + initial_col - y_) * (4 + initial_col - y_) + input_data.s4 * (5 + initial_col - y_) * (5 + initial_col - y_) + input_data.s5 * (6 + initial_col - y_) * (6 + initial_col - y_) + input_data.s6 * (7 + initial_col - y_) * (7 + initial_col - y_) + input_data.s7 * (8 + initial_col - y_) * (8 + initial_col - y_);

  float momentX3 = input_data.s0 * (1 + initial_col - y_) * (1 + initial_col - y_) * (1 + initial_col - y_) + input_data.s1 * (2 + initial_col - y_) * (2 + initial_col - y_) * (2 + initial_col - y_) + input_data.s2 * (3 + initial_col - y_) * (3 + initial_col - y_) * (3 + initial_col - y_) + input_data.s3 * (4 + initial_col - y_) * (4 + initial_col - y_) * (4 + initial_col - y_) + input_data.s4 * (5 + initial_col - y_) * (5 + initial_col - y_) * (5 + initial_col - y_) + input_data.s5 * (6 + initial_col - y_) * (6 + initial_col - y_) * (6 + initial_col - y_) + input_data.s6 * (7 + initial_col - y_) * (7 + initial_col - y_) * (7 + initial_col - y_) + input_data.s7 * (8 + initial_col - y_) * (8 + initial_col - y_) * (8 + initial_col - y_);

  local_result[hook(3, get_local_id(0) + get_local_size(0) * 0)] = momentX0;
  local_result[hook(3, get_local_id(0) + get_local_size(0) * 1)] = momentX1;
  local_result[hook(3, get_local_id(0) + get_local_size(0) * 2)] = momentX2;
  local_result[hook(3, get_local_id(0) + get_local_size(0) * 3)] = momentX3;

  barrier(0x01);
  float local_sum = 0;
  float local_MX0 = 0, local_MX1 = 0, local_MX2 = 0, local_MX3 = 0;

  if (get_local_id(0) == 0) {
    for (int i = 0; i < get_local_size(0); i++) {
      local_MX0 += local_result[hook(3, i + get_local_size(0) * 0)];
      local_MX1 += local_result[hook(3, i + get_local_size(0) * 1)];
      local_MX2 += local_result[hook(3, i + get_local_size(0) * 2)];
      local_MX3 += local_result[hook(3, i + get_local_size(0) * 3)];
    }

    group_result[hook(1, 0 + 4 * row)] = local_MX0;
    group_result[hook(1, 1 + 4 * row)] = local_MX1;
    group_result[hook(1, 2 + 4 * row)] = local_MX2;
    group_result[hook(1, 3 + 4 * row)] = local_MX3;

    atomic_dec(workgroups_left);

    if (0 == *workgroups_left) {
      const int number_of_workgroups = get_global_size(0) / get_local_size(0);
      const int COMPUTED_MOMENTS = 4;
      float moment11 = 0.0, moment12 = 0.0, moment30 = 0, moment03 = 0, moment02 = 0, moment20 = 0, moment21 = 0;

      for (int i = 0; i < number_of_workgroups; i++) {
        moment02 += group_result[hook(1, 2 + i * COMPUTED_MOMENTS)];
        moment03 += group_result[hook(1, 3 + i * COMPUTED_MOMENTS)];
        moment11 += (i + 1 - x_) * group_result[hook(1, 1 + i * COMPUTED_MOMENTS)];
        moment12 += (i + 1 - x_) * group_result[hook(1, 2 + i * COMPUTED_MOMENTS)];
        moment21 += (i + 1 - x_) * (i + 1 - x_) * group_result[hook(1, 1 + i * COMPUTED_MOMENTS)];
        moment20 += (i + 1 - x_) * (i + 1 - x_) * group_result[hook(1, 0 + i * COMPUTED_MOMENTS)];
        moment30 += (i + 1 - x_) * (i + 1 - x_) * (i + 1 - x_) * group_result[hook(1, 0 + i * COMPUTED_MOMENTS)];
      }

      central_moments[hook(4, 0)] = moment20;
      central_moments[hook(4, 1)] = moment30;
      central_moments[hook(4, 2)] = moment11;
      central_moments[hook(4, 3)] = moment21;
      central_moments[hook(4, 4)] = moment02;
      central_moments[hook(4, 5)] = moment12;
      central_moments[hook(4, 6)] = moment03;
    }
  }
}