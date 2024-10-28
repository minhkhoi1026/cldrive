//{"alpha":0,"p":3,"pnew":9,"pold":6,"u":1,"unew":7,"uold":4,"v":2,"vnew":8,"vold":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void l300(double alpha, global double* u, global double* v, global double* p, global double* uold, global double* vold, global double* pold, global double* unew, global double* vnew, global double* pnew) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  uold[hook(4, (y) * (64 + 1) + (x))] = u[hook(1, (y) * (64 + 1) + (x))] + alpha * (unew[hook(7, (y) * (64 + 1) + (x))] - 2. * u[hook(1, (y) * (64 + 1) + (x))] + uold[hook(4, (y) * (64 + 1) + (x))]);
  vold[hook(5, (y) * (64 + 1) + (x))] = v[hook(2, (y) * (64 + 1) + (x))] + alpha * (vnew[hook(8, (y) * (64 + 1) + (x))] - 2. * v[hook(2, (y) * (64 + 1) + (x))] + vold[hook(5, (y) * (64 + 1) + (x))]);
  pold[hook(6, (y) * (64 + 1) + (x))] = p[hook(3, (y) * (64 + 1) + (x))] + alpha * (pnew[hook(9, (y) * (64 + 1) + (x))] - 2. * p[hook(3, (y) * (64 + 1) + (x))] + pold[hook(6, (y) * (64 + 1) + (x))]);

  u[hook(1, (y) * (64 + 1) + (x))] = unew[hook(7, (y) * (64 + 1) + (x))];
  v[hook(2, (y) * (64 + 1) + (x))] = vnew[hook(8, (y) * (64 + 1) + (x))];
  p[hook(3, (y) * (64 + 1) + (x))] = pnew[hook(9, (y) * (64 + 1) + (x))];
}