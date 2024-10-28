//{"alpha":3,"direction":0,"n":2,"old_delta":4,"prev_direction":1,"weights":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void adjust_weights_quickprop(global const float* direction, global const float* prev_direction, float n, float alpha, global float* old_delta, global float* weights) {
  int gid = get_global_id(0);

  float new_delta;

  if (fabs(old_delta[hook(4, gid)]) > 1e-8)
    new_delta = min(direction[hook(0, gid)] / (prev_direction[hook(1, gid)] - direction[hook(0, gid)]), alpha) * old_delta[hook(4, gid)];
  else
    new_delta = -n * direction[hook(0, gid)];

  weights[hook(5, gid)] += new_delta;
  old_delta[hook(4, gid)] = new_delta;
}