//{"cols":4,"dx":0,"dx_offset":6,"dx_step":5,"dy":1,"dy_offset":8,"dy_step":7,"mag":2,"mag_offset":10,"mag_step":9,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float calc(int x, int y) {
  return (float)abs(x) + abs(y);
}
kernel void calcMagnitude(global const int* dx, global const int* dy, global float* mag, int rows, int cols, int dx_step, int dx_offset, int dy_step, int dy_offset, int mag_step, int mag_offset) {
  dx_step /= sizeof(*dx);
  dx_offset /= sizeof(*dx);
  dy_step /= sizeof(*dy);
  dy_offset /= sizeof(*dy);
  mag_step /= sizeof(*mag);
  mag_offset /= sizeof(*mag);

  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  if (gidy < rows && gidx < cols) {
    mag[hook(2, (gidx + 1) + (gidy + 1) * mag_step + mag_offset)] = calc(dx[hook(0, gidx + gidy * dx_step + dx_offset)], dy[hook(1, gidx + gidy * dy_step + dy_offset)]);
  }
}