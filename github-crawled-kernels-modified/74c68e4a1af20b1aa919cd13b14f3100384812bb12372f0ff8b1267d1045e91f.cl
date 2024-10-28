//{"blurx":1,"depth":4,"grid":0,"sh":3,"sw":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_blur_x(global const float8* grid, global float8* blurx, int sw, int sh, int depth) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  for (int d = 0; d < depth; d++) {
    const int xp = max(x - 1, 0);
    const int xn = min(x + 1, sw - 1);

    float8 v = grid[hook(0, xp + sw * (y + d * sh))] + 4.0f * grid[hook(0, x + sw * (y + d * sh))] + grid[hook(0, xn + sw * (y + d * sh))];

    blurx[hook(1, x + sw * (y + d * sh))] = v;
  }
}