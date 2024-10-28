//{"beta":1,"direction":2,"layer_gradient":0,"prev_gradient":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void calc_conjugate_gradient_direction(global const float* layer_gradient, global const float* beta, global float* direction, global float* prev_gradient) {
  int gid = get_global_id(0);

  prev_gradient[hook(3, gid)] = layer_gradient[hook(0, gid)];
  direction[hook(2, gid)] = layer_gradient[hook(0, gid)] + beta[hook(1, 0)] * direction[hook(2, gid)];
}