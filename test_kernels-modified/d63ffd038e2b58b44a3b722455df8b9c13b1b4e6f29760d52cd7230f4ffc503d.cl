//{"cache":2,"decay_rate":4,"dx":1,"eps":5,"learn_rate":3,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_rmsprop_f32(global float* x, global float* dx, global float* cache, float learn_rate, float decay_rate, float eps) {
  unsigned int i = get_global_id(0);
  cache[hook(2, i)] = decay_rate * cache[hook(2, i)] + (1.f - decay_rate) * dx[hook(1, i)] * dx[hook(1, i)];
  x[hook(0, i)] += learn_rate * dx[hook(1, i)] / (sqrt(cache[hook(2, i)]) + eps);
}