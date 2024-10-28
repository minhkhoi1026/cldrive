//{"p":2,"pold":5,"u":0,"uold":3,"v":1,"vold":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_pc(global double* u, global double* v, global double* p, global double* uold, global double* vold, global double* pold) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < 64) {
    u[hook(0, (0) * (64 + 1) + (x))] = u[hook(0, (64) * (64 + 1) + (x))];
    v[hook(1, (64) * (64 + 1) + (x + 1))] = v[hook(1, (0) * (64 + 1) + (x + 1))];
  }

  if (y < 64) {
    u[hook(0, (y + 1) * (64 + 1) + (64))] = u[hook(0, (y + 1) * (64 + 1) + (0))];
    v[hook(1, (y) * (64 + 1) + (0))] = v[hook(1, (y) * (64 + 1) + (64))];
  }

  u[hook(0, (0) * (64 + 1) + (64))] = u[hook(0, (64) * (64 + 1) + (0))];
  v[hook(1, (64) * (64 + 1) + (0))] = v[hook(1, (0) * (64 + 1) + (64))];

  uold[hook(3, (y) * (64 + 1) + (x))] = u[hook(0, (y) * (64 + 1) + (x))];
  vold[hook(4, (y) * (64 + 1) + (x))] = v[hook(1, (y) * (64 + 1) + (x))];
  pold[hook(5, (y) * (64 + 1) + (x))] = p[hook(2, (y) * (64 + 1) + (x))];
}