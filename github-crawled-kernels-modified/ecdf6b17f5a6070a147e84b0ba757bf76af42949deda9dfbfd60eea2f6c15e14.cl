//{"x_new":0,"x_old":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void stencil_kernel(global float* x_new, global float* x_old) {
  int x = get_group_id(0) * 2048 + get_local_id(0);
  int y = get_group_id(1) * 1024 + get_local_id(1);

  if (y > 0 && y < 2048 - 1 && x > 0 && x < 4096 - 1) {
    x_new[hook(0, y * 4096 + x)] = (x_old[hook(1, (y) * 4096 + (x))] + x_old[hook(1, (y) * 4096 + (x - 1))] + x_old[hook(1, (y) * 4096 + (x + 1))] + x_old[hook(1, (y + 1) * 4096 + (x))] + x_old[hook(1, (y - 1) * 4096 + (x))]) / 5.0f;
  }
}