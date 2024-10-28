//{"u0":0,"u1":1,"width_ptr":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update_grid(global float* u0, global float* u1, global const int* width_ptr) {
  int id = get_global_id(0);

  int width = width_ptr[hook(2, 0)];

  int row = id / width;
  int col = id % width;

  if (row > 0 && col > 0 && row < width - 1 && col < width - 1) {
    u0[hook(0, row * width + col)] = .25 * (u1[hook(1, (row + 1) * width + col)] + u1[hook(1, (row - 1) * width + col)] + u1[hook(1, row * width + (col + 1))] + u1[hook(1, row * width + (col - 1))]);
  }
}