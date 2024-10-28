//{"count":2,"in_data":6,"new_steps":4,"new_steps_private":8,"num_axes":1,"old_steps":5,"out_data":0,"permute_order":3,"permute_order_private":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_permute_fwd(global float* out_data, const int num_axes, const int count, global const int* permute_order, global const int* new_steps, global const int* old_steps, global const float* in_data) {
  int global_idx = get_global_id(0);
  int org_idx = global_idx;
  int4 permute_order_private_4;
  int4 new_steps_private_4;
  int permute_order_private[4];
  int new_steps_private[4];

  if (global_idx < count) {
    int in_idx = 0;

    permute_order_private_4 = *((global const int4*)(&permute_order[hook(3, 0)]));
    new_steps_private_4 = *((global const int4*)(&new_steps[hook(4, 0)]));
    permute_order_private[hook(7, 0)] = permute_order_private_4.x;
    permute_order_private[hook(7, 1)] = permute_order_private_4.y;
    permute_order_private[hook(7, 2)] = permute_order_private_4.z;
    permute_order_private[hook(7, 3)] = permute_order_private_4.w;
    new_steps_private[hook(8, 0)] = new_steps_private_4.x;
    new_steps_private[hook(8, 1)] = new_steps_private_4.y;
    new_steps_private[hook(8, 2)] = new_steps_private_4.z;
    new_steps_private[hook(8, 3)] = new_steps_private_4.w;

    for (int i = 0; i < num_axes; i++) {
      int order = permute_order_private[hook(7, i)];
      int new_step = new_steps_private[hook(8, i)];
      int old_step = old_steps[hook(5, order)];
      in_idx += (org_idx / new_step) * old_step;
      org_idx %= new_step;
    }

    out_data[hook(0, global_idx)] = in_data[hook(6, in_idx)];
  }
}