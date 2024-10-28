//{"res":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sine_gpu(global int* src, global float* res) {
  const int hx = get_global_size(0);

  const int idx = get_global_id(0);
  const int idy = get_global_id(1);
  int tmp = idx;

  const float angle = (float)src[hook(0, idy * hx + idx)] / 50.0f;
  while (tmp < hx)
    tmp++;
  res[hook(1, idy * hx + idx)] = 10.0f * sin(angle * 2.0f * 3.14159265358979323846264338327950288f);
}