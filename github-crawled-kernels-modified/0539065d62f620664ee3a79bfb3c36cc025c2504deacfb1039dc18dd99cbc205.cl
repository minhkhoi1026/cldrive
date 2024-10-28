//{"cu":0,"cv":1,"h":3,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void l100_pc(global double* cu, global double* cv, global double* z, global double* h) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  cu[hook(0, (0) * (64 + 1) + (64))] = cu[hook(0, (64) * (64 + 1) + (0))];
  cv[hook(1, (64) * (64 + 1) + (0))] = cv[hook(1, (0) * (64 + 1) + (64))];
  z[hook(2, (0) * (64 + 1) + (0))] = z[hook(2, (64) * (64 + 1) + (64))];
  h[hook(3, (64) * (64 + 1) + (64))] = h[hook(3, (0) * (64 + 1) + (0))];

  if (x < 64) {
    cu[hook(0, (0) * (64 + 1) + (x))] = cu[hook(0, (64) * (64 + 1) + (x))];
    cv[hook(1, (64) * (64 + 1) + (x + 1))] = cv[hook(1, (0) * (64 + 1) + (x + 1))];
    z[hook(2, (0) * (64 + 1) + (x + 1))] = z[hook(2, (64) * (64 + 1) + (x + 1))];
    h[hook(3, (64) * (64 + 1) + (x))] = h[hook(3, (0) * (64 + 1) + (x))];
  }

  if (y < 64) {
    cu[hook(0, (y + 1) * (64 + 1) + (64))] = cu[hook(0, (y + 1) * (64 + 1) + (0))];
    cv[hook(1, (y) * (64 + 1) + (0))] = cv[hook(1, (y) * (64 + 1) + (64))];
    z[hook(2, (y + 1) * (64 + 1) + (0))] = z[hook(2, (y + 1) * (64 + 1) + (64))];
    h[hook(3, (y) * (64 + 1) + (64))] = h[hook(3, (y) * (64 + 1) + (0))];
  }
}