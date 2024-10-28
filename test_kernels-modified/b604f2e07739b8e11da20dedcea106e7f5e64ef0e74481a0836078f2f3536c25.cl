//{"count":4,"in_data_a":2,"in_data_b":3,"out_data":0,"with_relu":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_elt_max(global float* out_data, const int with_relu, global const float* in_data_a, global const float* in_data_b, int count) {
  int idx = get_global_id(0);

  if (idx < count) {
    float tmp;
    float var_a = in_data_a[hook(2, idx)];
    float var_b = in_data_b[hook(3, idx)];
    int a_gt_b = var_a > var_b;
    tmp = a_gt_b ? var_a : var_b;

    out_data[hook(0, idx)] = tmp;
  }
}