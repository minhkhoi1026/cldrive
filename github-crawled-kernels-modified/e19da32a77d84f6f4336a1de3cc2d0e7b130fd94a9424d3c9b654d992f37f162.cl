//{"delta":7,"in_c":3,"in_h":1,"in_w":2,"indexes":9,"n":0,"pad":6,"prev_delta":8,"size":5,"stride":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void backward_maxpool_layer_kernel(int n, int in_h, int in_w, int in_c, int stride, int size, int pad, global float* delta, global float* prev_delta, global int* indexes) {
  int h = (in_h + 2 * pad) / stride;
  int w = (in_w + 2 * pad) / stride;
  int c = in_c;
  int area = (size - 1) / stride;

  int id = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (id >= n)
    return;

  int index = id;
  int j = id % in_w;
  id /= in_w;
  int i = id % in_h;
  id /= in_h;
  int k = id % in_c;
  id /= in_c;
  int b = id;

  int w_offset = -pad;
  int h_offset = -pad;

  float d = 0;
  int l, m;
  for (l = -area; l < area + 1; ++l) {
    for (m = -area; m < area + 1; ++m) {
      int out_w = (j - w_offset) / stride + m;
      int out_h = (i - h_offset) / stride + l;
      int out_index = out_w + w * (out_h + h * (k + c * b));
      int valid = (out_w >= 0 && out_w < w && out_h >= 0 && out_h < h);
      d += (valid && indexes[hook(9, out_index)] == index) ? delta[hook(7, out_index)] : 0;
    }
  }
  prev_delta[hook(8, index)] += d;
}