//{"grid":1,"n":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void p2p64(const int n, global double* grid) {
  const int j = get_global_id(0);
  for (int i = 2; i <= 2 * n - 2; i++) {
    if ((j >= max(2, i - n + 2)) && (j <= min(i, n))) {
      const int x = i - j + 2 - 1;
      const int y = j - 1;
      grid[hook(1, x * n + y)] = grid[hook(1, (x - 1) * n + y)] + grid[hook(1, x * n + (y - 1))] - grid[hook(1, (x - 1) * n + (y - 1))];
    }
    barrier(0x01 | 0x02);
  }
}