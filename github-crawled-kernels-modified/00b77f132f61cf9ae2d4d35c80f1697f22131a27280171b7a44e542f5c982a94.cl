//{"pnew":2,"unew":0,"vnew":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void l200_pc(global double* unew, global double* vnew, global double* pnew) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < 64) {
    unew[hook(0, (0) * (64 + 1) + (x))] = unew[hook(0, (64) * (64 + 1) + (x))];
    vnew[hook(1, (64) * (64 + 1) + (x + 1))] = vnew[hook(1, (0) * (64 + 1) + (x + 1))];
    pnew[hook(2, (64) * (64 + 1) + (x))] = pnew[hook(2, (0) * (64 + 1) + (x))];
  }

  if (y < 64) {
    unew[hook(0, (y + 1) * (64 + 1) + (64))] = unew[hook(0, (y + 1) * (64 + 1) + (0))];
    vnew[hook(1, (y) * (64 + 1) + (0))] = vnew[hook(1, (y) * (64 + 1) + (64))];
    pnew[hook(2, (y) * (64 + 1) + (64))] = pnew[hook(2, (y) * (64 + 1) + (0))];
  }

  unew[hook(0, (0) * (64 + 1) + (64))] = unew[hook(0, (64) * (64 + 1) + (0))];
  vnew[hook(1, (64) * (64 + 1) + (0))] = vnew[hook(1, (0) * (64 + 1) + (64))];
  pnew[hook(2, (64) * (64 + 1) + (64))] = pnew[hook(2, (0) * (64 + 1) + (0))];
}