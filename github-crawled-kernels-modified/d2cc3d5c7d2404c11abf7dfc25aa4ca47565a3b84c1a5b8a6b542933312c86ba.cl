//{"in_c":8,"in_c_stride":4,"in_data":1,"in_max_index":2,"in_n":7,"in_n_stride":3,"num_threads":9,"out_c_stride":6,"out_data":0,"out_n_stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Unpool(global float* out_data, global const float* in_data, global const float* in_max_index, const int in_n_stride, const int in_c_stride, const int out_n_stride, const int out_c_stride, const int in_n, const int in_c, const int num_threads) {
  int tid = get_global_id(0);
  if (tid < num_threads) {
    int n = (tid / in_n_stride) % in_n;
    int c = (tid / in_c_stride) % in_c;
    int out_offset = n * out_n_stride + c * out_c_stride;
    int index = in_max_index[hook(2, tid)];
    out_data[hook(0, out_offset + index)] = in_data[hook(1, tid)];
  }
}