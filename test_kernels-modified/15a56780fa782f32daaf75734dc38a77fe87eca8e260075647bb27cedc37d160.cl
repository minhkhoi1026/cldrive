//{"alpha":2,"direction":0,"n":1,"old_delta":3,"weights":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void adjust_weights(global const float* direction, float n, float alpha, global float* old_delta, global float* weights) {
  int gid = get_global_id(0);

  float new_delta = n * (-direction[hook(0, gid)]) + alpha * old_delta[hook(3, gid)];

  weights[hook(4, gid)] += new_delta;
  old_delta[hook(3, gid)] = new_delta;
}