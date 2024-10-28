//{"d_x":1,"d_y":0,"num":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_kernel(global float* d_y, global const float* d_x, const int num) {
  const int id = get_global_id(0);

  if (id < num) {
    float x = d_x[hook(1, id)];
    float sin_x = sin(x);
    float cos_x = cos(x);
    d_y[hook(0, id)] = (sin_x * sin_x) + (cos_x * cos_x);
  }
}