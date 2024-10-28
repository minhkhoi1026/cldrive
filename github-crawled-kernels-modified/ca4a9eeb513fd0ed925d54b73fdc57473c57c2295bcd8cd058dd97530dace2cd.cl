//{"add":10,"batch":6,"c1":9,"c2":13,"h1":8,"h2":12,"minc":3,"minh":2,"minw":1,"out":16,"s1":14,"s2":15,"samples":5,"size":0,"stride":4,"w1":7,"w2":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void shortcut_kernel(int size, int minw, int minh, int minc, int stride, int samples, int batch, int w1, int h1, int c1, global float* add, int w2, int h2, int c2, float s1, float s2, global float* out) {
  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= size)
    return;
  int i = id % minw;
  id /= minw;
  int j = id % minh;
  id /= minh;
  int k = id % minc;
  id /= minc;
  int b = id % batch;
  int out_index = i * samples + w2 * (j * samples + h2 * (k + c2 * b));
  int add_index = i * stride + w1 * (j * stride + h1 * (k + c1 * b));
  out[hook(16, out_index)] = s1 * out[hook(16, out_index)] + s2 * add[hook(10, add_index)];
}