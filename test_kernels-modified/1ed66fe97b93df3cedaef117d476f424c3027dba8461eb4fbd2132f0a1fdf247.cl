//{"beta":5,"gradient":0,"num_components":2,"partial_sum_down":4,"partial_sum_up":3,"prev_gradient":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void calc_conjugate_gradient_beta(global const float* gradient, global const float* prev_gradient, int num_components, local float* partial_sum_up, local float* partial_sum_down, global float* beta) {
  int lid = get_local_id(0);

  float up = 0.0f;
  float down = 0.0f;
  for (unsigned int x = lid; x < num_components; x += get_local_size(0)) {
    up += gradient[hook(0, x)] * (gradient[hook(0, x)] - prev_gradient[hook(1, x)]);
    down += prev_gradient[hook(1, x)] * prev_gradient[hook(1, x)];
  }

  partial_sum_up[hook(3, lid)] = up;
  partial_sum_down[hook(4, lid)] = down;

  for (unsigned int stride = get_local_size(0) / 2; stride > 0; stride /= 2) {
    barrier(0x01);
    if (lid < stride) {
      partial_sum_up[hook(3, lid)] += partial_sum_up[hook(3, lid + stride)];
      partial_sum_down[hook(4, lid)] += partial_sum_down[hook(4, lid + stride)];
    }
  }

  if (get_global_id(0) == 0)
    beta[hook(5, 0)] = fabs(partial_sum_down[hook(4, 0)]) < 1e-3 ? 0.0 : max(0.0f, partial_sum_up[hook(3, 0)] / partial_sum_down[hook(4, 0)]);
}