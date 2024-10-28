//{"depth":3,"grid":0,"sh":2,"sw":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bilateral_init(global float8* grid, int sw, int sh, int depth) {
  const int gid_x = get_global_id(0);
  const int gid_y = get_global_id(1);

  for (int d = 0; d < depth; d++) {
    grid[hook(0, gid_x + sw * (gid_y + d * sh))] = (float8)(0.0f);
  }
}