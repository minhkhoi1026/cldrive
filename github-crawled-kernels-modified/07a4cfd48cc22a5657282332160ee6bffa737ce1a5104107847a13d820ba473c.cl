//{"M":0,"M_LEN":2,"N":1,"cu":3,"cv":4,"h":6,"z":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sw_update0(const unsigned M, const unsigned N, const unsigned M_LEN, global double* cu, global double* cv, global double* z, global double* h) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < N) {
    cu[hook(3, x)] = cu[hook(3, M * M_LEN + x)];
    cv[hook(4, M * M_LEN + x + 1)] = cv[hook(4, x + 1)];
    z[hook(5, x + 1)] = z[hook(5, M * M_LEN + x + 1)];
    h[hook(6, M * M_LEN + x)] = h[hook(6, x)];
  }

  if (y < M) {
    cu[hook(3, (y + 1) * M_LEN + N)] = cu[hook(3, (y + 1) * M_LEN)];
    cv[hook(4, y * M_LEN)] = cv[hook(4, y * M_LEN + N)];
    z[hook(5, (y + 1) * M_LEN)] = z[hook(5, (y + 1) * M_LEN + N)];
    h[hook(6, y * M_LEN + N)] = h[hook(6, y * M_LEN)];
  }

  cu[hook(3, N)] = cu[hook(3, M * M_LEN)];
  cv[hook(4, M * M_LEN)] = cv[hook(4, N)];
  z[hook(5, 0)] = z[hook(5, M * M_LEN + N)];
  h[hook(6, M * M_LEN + N)] = h[hook(6, 0)];
}