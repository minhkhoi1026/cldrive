//{"D":3,"V":2,"colVector":9,"colVector[j]":8,"dist":5,"dist[py]":4,"m":0,"n":1,"rowVector":7,"rowVector[py]":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeDist(int m, int n, global int* V, global int* D) {
  local int rowVector[32][128];
  local int colVector[128][32];
  local int dist[32][32];

  int bx = get_group_id(0);
  int by = get_group_id(1);

  int tx = get_local_id(0);
  int ty = get_local_id(1);

  int row;
  int col;
  int px;
  int py;

  for (py = ty; py < 32; py += get_local_size(1)) {
    for (px = tx; px < 32; px += get_local_size(0)) {
      row = by * 32 + py;
      col = bx * 32 + px;
      dist[hook(5, py)][hook(4, px)] = 0;
      barrier(0x01);

      for (int i = 0; i < (int)(ceil((float)n / 128)); i++) {
        for (int j = tx; j < 128; j += get_local_size(0)) {
          rowVector[hook(7, py)][hook(6, j)] = V[hook(2, row * n + i * 128 + j)];
        }
        for (int j = ty; j < 128; j += get_local_size(1)) {
          colVector[hook(9, j)][hook(8, px)] = V[hook(2, col * n + i * 128 + j)];
        }
        barrier(0x01);

        for (int j = 0; j < 128; j++) {
          dist[hook(5, py)][hook(4, px)] += (rowVector[hook(7, py)][hook(6, j)] - colVector[hook(9, j)][hook(8, px)]) * (rowVector[hook(7, py)][hook(6, j)] - colVector[hook(9, j)][hook(8, px)]);
        }
        barrier(0x01);
      }
      D[hook(3, row * m + col)] = dist[hook(5, py)][hook(4, px)];
    }
  }
}