//{"delta":3,"error":4,"n":0,"pred":1,"truth":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smooth_l1_kernel(int n, global float* pred, global float* truth, global float* delta, global float* error) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < n) {
    float diff = truth[hook(2, i)] - pred[hook(1, i)];
    float abs_val = fabs(diff);
    if (abs_val < 1) {
      error[hook(4, i)] = diff * diff;
      delta[hook(3, i)] = diff;
    } else {
      error[hook(4, i)] = 2 * abs_val - 1;
      delta[hook(3, i)] = (diff > 0) ? 1 : -1;
    }
  }
}