//{"p":2,"r":1,"r_dot_r":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_p(global float* r_dot_r, global float* r, global float* p) {
  int id = get_global_id(0);
  float beta = r_dot_r[hook(0, 1)] / r_dot_r[hook(0, 0)];
  p[hook(2, id)] = r[hook(1, id)] + beta * p[hook(2, id)];
}