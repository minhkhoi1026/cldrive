//{"c":4,"delta":7,"h":3,"n":1,"rate":6,"size":5,"w":2,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void smooth_kernel(global float* x, int n, int w, int h, int c, int size, float rate, global float* delta) {
  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= n)
    return;

  int j = id % w;
  id /= w;
  int i = id % h;
  id /= h;
  int k = id % c;
  id /= c;
  int b = id;

  int w_offset = -(size / 2.f);
  int h_offset = -(size / 2.f);

  int out_index = j + w * (i + h * (k + c * b));
  int l, m;
  for (l = 0; l < size; ++l) {
    for (m = 0; m < size; ++m) {
      int cur_h = h_offset + i + l;
      int cur_w = w_offset + j + m;
      int index = cur_w + w * (cur_h + h * (k + b * c));
      int valid = (cur_h >= 0 && cur_h < h && cur_w >= 0 && cur_w < w);
      delta[hook(7, out_index)] += valid ? rate * (x[hook(0, index)] - x[hook(0, out_index)]) : 0;
    }
  }
}