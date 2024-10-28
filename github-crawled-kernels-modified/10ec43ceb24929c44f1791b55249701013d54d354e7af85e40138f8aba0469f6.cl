//{"A":2,"a":4,"dt":3,"u":0,"v":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nonlinearpart_a(global double2* u, global double2* v, const double A, const double dt, const double a) {
  const int ind = get_global_id(0);

  u[hook(0, ind)].x = u[hook(0, ind)].x * exp(dt * a * (-1.0) * v[hook(1, ind)].x * v[hook(1, ind)].x);
  u[hook(0, ind)].y = 0.0;
}