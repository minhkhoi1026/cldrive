//{"c":2,"s":3,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Srot_noinc(global float* x, global float* y, float c, float s) {
  unsigned int gid = get_global_id(0);

  float current_x = x[hook(0, gid)];
  float current_y = y[hook(1, gid)];

  float sy = s * current_y;
  float _x = fma(c, current_x, sy);

  float cy = c * current_y;
  y[hook(1, gid)] = fma(-s, current_x, cy);

  x[hook(0, gid)] = _x;
}