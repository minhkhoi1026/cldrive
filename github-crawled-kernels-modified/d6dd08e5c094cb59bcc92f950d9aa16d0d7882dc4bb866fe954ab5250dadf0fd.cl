//{"gradient":0,"n":2,"prev_gradient":1,"weights":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float beta = 0.66666f;
kernel void adjust_weights_rprop(global const float* gradient, global const float* prev_gradient, global float* n, global float* weights) {
  int gid = get_global_id(0);

  if (fabs(gradient[hook(0, gid)]) < 1e-6f)
    return;

  float new_delta;
  float factor = prev_gradient[hook(1, gid)] * gradient[hook(0, gid)];

  const float a = 1.2f;
  const float b = 0.5f;

  if (factor > 1e-6f)
    n[hook(2, gid)] = min(a * n[hook(2, gid)], 50.0f);
  else if (factor < -1e-6f)
    n[hook(2, gid)] = max(b * n[hook(2, gid)], 1e-6f);

  weights[hook(3, gid)] += n[hook(2, gid)] * (gradient[hook(0, gid)] > 0.0f ? -1.0f : 1.0f);
}