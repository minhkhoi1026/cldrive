//{"errors":6,"partial_sum":5,"real_outputs":1,"real_outputs_count":3,"real_outputs_ofs":2,"target_outputs":4,"total_count":0,"total_errors":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void setup_training_data(int total_count, global const float* real_outputs, int real_outputs_ofs, int real_outputs_count, global const float* target_outputs, local float* partial_sum, global float* errors, global float* total_errors) {
  int lid = get_local_id(0);

  float sum = 0.0f;
  for (unsigned int x = lid; x < total_count; x += get_local_size(0)) {
    if (x < real_outputs_ofs || x >= real_outputs_ofs + real_outputs_count) {
      errors[hook(6, x)] = 0.0f;
      continue;
    }

    float err = real_outputs[hook(1, x)] - target_outputs[hook(4, x - real_outputs_ofs)];
    errors[hook(6, x)] = err * beta * (1.0f - real_outputs[hook(1, x)] * real_outputs[hook(1, x)]);

    sum += err * err;
  }

  partial_sum[hook(5, lid)] = sum;

  for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
    barrier(0x01);
    if (lid < stride)
      partial_sum[hook(5, lid)] += partial_sum[hook(5, lid + stride)];
  }

  if (get_global_id(0) == 0)
    total_errors[hook(7, 0)] += native_sqrt(partial_sum[hook(5, 0)]);
}