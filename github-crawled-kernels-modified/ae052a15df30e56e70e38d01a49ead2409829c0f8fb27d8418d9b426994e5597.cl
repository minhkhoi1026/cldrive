//{"A":2,"b":4,"dt":3,"u":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nonlinearpart_b(global double2* u, global double2* v, const double A, const double dt, const double b) {
  const int ind = get_global_id(0);

  v[hook(1, ind)].x = 1.0 / (-0.5 * A * (dt * dt * b * b) - u[hook(0, ind)].x * (dt * b) + 1 / v[hook(1, ind)].x);
  v[hook(1, ind)].y = 0.0;
  u[hook(0, ind)].x = A * dt * b + u[hook(0, ind)].x;
}