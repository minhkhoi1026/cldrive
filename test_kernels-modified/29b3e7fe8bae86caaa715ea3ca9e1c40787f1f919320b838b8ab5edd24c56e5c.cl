//{"PENALTY1":8,"PENALTY2":9,"curr_cost":3,"d":7,"disp_range":6,"height":5,"local_cost":1,"path_intensity_gradient":2,"prior_cost":0,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void evaluate_path_ocl(global float* prior_cost, global float* local_cost, float path_intensity_gradient, global float* curr_cost, int width, int height, int disp_range, int d, float PENALTY1, float PENALTY2) {
  float min_int = 0x1.fffffep127f;

  float e_smooth = 0x1.fffffep127f;
  for (int d_p = 0; d_p < disp_range; d_p++) {
    if (prior_cost[hook(0, d_p)] < min_int)
      min_int = prior_cost[hook(0, d_p)];

    if (d_p - d == 0) {
      e_smooth = fmin(e_smooth, prior_cost[hook(0, d_p)]);
    } else if (abs(d_p - d) == 1) {
      e_smooth = fmin(e_smooth, prior_cost[hook(0, d_p)] + PENALTY1);
    } else {
      float penalty = PENALTY2 / path_intensity_gradient;

      e_smooth = fmin(e_smooth, prior_cost[hook(0, d_p)] + fmax(PENALTY1, penalty));
    }
  }
  curr_cost[hook(3, d)] = local_cost[hook(1, d)] + e_smooth - min_int;
}