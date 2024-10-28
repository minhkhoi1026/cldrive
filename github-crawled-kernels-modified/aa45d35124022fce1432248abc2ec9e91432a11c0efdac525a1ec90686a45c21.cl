//{"p":2,"pnew":8,"pold":5,"u":0,"unew":6,"uold":3,"v":1,"vnew":7,"vold":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void l300_pc(global double* u, global double* v, global double* p, global double* uold, global double* vold, global double* pold, global double* unew, global double* vnew, global double* pnew) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  uold[hook(3, (y) * (64 + 1) + (x))] = u[hook(0, (y) * (64 + 1) + (x))];
  vold[hook(4, (y) * (64 + 1) + (x))] = v[hook(1, (y) * (64 + 1) + (x))];
  pold[hook(5, (y) * (64 + 1) + (x))] = p[hook(2, (y) * (64 + 1) + (x))];

  u[hook(0, (y) * (64 + 1) + (x))] = unew[hook(6, (y) * (64 + 1) + (x))];
  v[hook(1, (y) * (64 + 1) + (x))] = vnew[hook(7, (y) * (64 + 1) + (x))];
  p[hook(2, (y) * (64 + 1) + (x))] = pnew[hook(8, (y) * (64 + 1) + (x))];
}