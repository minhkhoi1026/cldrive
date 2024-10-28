//{"mat_p":3,"p":2,"p_dot_mat_p":1,"r":5,"r_dot_r":0,"x":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_xr(global float* r_dot_r, global float* p_dot_mat_p, global float* p, global float* mat_p, global float* x, global float* r) {
  int id = get_global_id(0);
  float alpha = r_dot_r[hook(0, 0)] / *p_dot_mat_p;
  x[hook(4, id)] += alpha * p[hook(2, id)];
  r[hook(5, id)] -= alpha * mat_p[hook(3, id)];
}