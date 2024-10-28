//{"count":2,"in_data":7,"new_steps":4,"new_valid_shape":6,"num_axes":1,"old_steps":5,"out_data":0,"permute_order":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_permute_fwd_new_shape(global float* out_data, const int num_axes, const int count, global const int* permute_order, global const int* new_steps, global const int* old_steps, global const int* new_valid_shape, global const float* in_data) {
  int global_idx = get_global_id(0);
  if (global_idx < count) {
    int in_idx = 0;
    int out_idx = 0;
    int new_valid_stride = 1;

    for (int i = num_axes - 1; i >= 0; --i) {
      int order = permute_order[hook(3, i)];
      int new_step = new_steps[hook(4, i)];
      int old_step = old_steps[hook(5, order)];
      int id = (global_idx / new_valid_stride) % new_valid_shape[hook(6, i)];
      in_idx += id * old_step;
      out_idx += id * new_step;
      new_valid_stride *= new_valid_shape[hook(6, i)];
    }

    out_data[hook(0, out_idx)] = in_data[hook(7, in_idx)];
  }
}