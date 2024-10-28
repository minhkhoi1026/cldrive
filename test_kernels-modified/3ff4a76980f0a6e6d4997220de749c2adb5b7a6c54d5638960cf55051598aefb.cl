//{"dx":1,"learn_rate":2,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_sgd_f32(global float* x, global float* dx, float learn_rate) {
  unsigned int i = get_global_id(0);
  x[hook(0, i)] += learn_rate * dx[hook(1, i)];
}