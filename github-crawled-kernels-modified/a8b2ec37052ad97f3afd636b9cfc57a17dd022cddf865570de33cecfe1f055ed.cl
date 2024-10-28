//{"gausscale":1,"probe_data":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gauss_multiply(global float2* probe_data, float gausscale) {
  size_t ix = get_global_id(0);
  size_t iy = get_global_id(1);
  size_t index = iy * get_global_size(0) + ix;

  size_t nx = get_global_size(0);
  size_t ny = get_global_size(1);

  float2 pd = probe_data[hook(0, index)];

  float r = exp(-((ix - nx / 2.0f) * (ix - nx / 2.0f) + (iy - ny / 2.0f) * (iy - ny / 2.0f)) / ((float)nx * (float)ny * gausscale));
  pd.s0 *= r;
  pd.s1 *= r;

  probe_data[hook(0, index)] = pd;
}