//{"ddx":0,"ddy":1,"xx":2,"xy":3,"yy":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void second_moment_matrix_elements(global float* ddx, global float* ddy, global float* xx, global float* xy, global float* yy) {
  int i = get_global_id(0);

  float dx = ddx[hook(0, i)];
  float dy = ddy[hook(1, i)];

  xx[hook(2, i)] = dx * dx;
  xy[hook(3, i)] = dx * dy;
  yy[hook(4, i)] = dy * dy;
}