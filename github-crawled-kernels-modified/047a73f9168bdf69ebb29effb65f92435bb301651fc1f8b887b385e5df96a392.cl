//{"alpha":0,"x":1,"y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Saxpy_noinc(float alpha, global float* x, global float* y) {
  unsigned int gid = get_global_id(0);
  float this_x = x[hook(1, gid)];
  float this_y = y[hook(2, gid)];
  this_y += alpha * this_x;
  y[hook(2, gid)] = this_y;
}