//{"dst":2,"k":3,"lx":0,"ly":1,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void AKAZE_pm_g2(global const float* lx, global const float* ly, global float* dst, float k, int size) {
  int i = get_global_id(0);

  if (!(i < size)) {
    return;
  }

  const float k2inv = 1.0f / (k * k);
  dst[hook(2, i)] = 1.0f / (1.0f + ((lx[hook(0, i)] * lx[hook(0, i)] + ly[hook(1, i)] * ly[hook(1, i)]) * k2inv));
}