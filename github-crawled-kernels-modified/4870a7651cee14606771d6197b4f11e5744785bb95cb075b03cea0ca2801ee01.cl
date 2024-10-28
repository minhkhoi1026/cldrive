//{"count":2,"in_data":9,"new_steps":4,"num_axes":1,"old_steps":5,"out_data":0,"permute_order":3,"power":8,"scale":6,"shift":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_permute_power_fwd(global float* out_data, const int num_axes, const int count, global const int* permute_order, global const int* new_steps, global const int* old_steps, const float scale, const float shift, const float power, global const float* in_data) {
  int global_idx = get_global_id(0);
  int org_idx = global_idx;
  int in_idx = 0;

  for (int i = 0; i < num_axes; i++) {
    int order = permute_order[hook(3, i)];
    int new_step = new_steps[hook(4, i)];
    int old_step = old_steps[hook(5, order)];
    in_idx += (org_idx / new_step) * old_step;
    org_idx %= new_step;
  }

  out_data[hook(0, global_idx)] = pow(scale * in_data[hook(9, in_idx)] + shift, power);
}