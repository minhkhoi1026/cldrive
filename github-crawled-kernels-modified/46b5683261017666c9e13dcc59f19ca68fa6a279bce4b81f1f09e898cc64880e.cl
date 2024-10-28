//{"in_c":3,"in_h":1,"in_w":2,"indexes":9,"input":7,"n":0,"output":8,"pad":6,"size":5,"stride":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void forward_maxpool_layer_kernel(int n, int in_h, int in_w, int in_c, int stride, int size, int pad, global float* input, global float* output, global int* indexes) {
  int h = (in_h + 2 * pad) / stride;
  int w = (in_w + 2 * pad) / stride;
  int c = in_c;

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

  int w_offset = -pad;
  int h_offset = -pad;

  int out_index = j + w * (i + h * (k + c * b));
  float max_value = -(__builtin_inff());
  int max_index = -1;
  int l, m;
  for (l = 0; l < size; ++l) {
    for (m = 0; m < size; ++m) {
      int cur_h = h_offset + i * stride + l;
      int cur_w = w_offset + j * stride + m;
      int index = cur_w + in_w * (cur_h + in_h * (k + b * in_c));
      int valid = (cur_h >= 0 && cur_h < in_h && cur_w >= 0 && cur_w < in_w);
      float val = (valid != 0) ? input[hook(7, index)] : -(__builtin_inff());
      max_index = (val > max_value) ? index : max_index;
      max_value = (val > max_value) ? val : max_value;
    }
  }
  output[hook(8, out_index)] = max_value;
  indexes[hook(9, out_index)] = max_index;
}