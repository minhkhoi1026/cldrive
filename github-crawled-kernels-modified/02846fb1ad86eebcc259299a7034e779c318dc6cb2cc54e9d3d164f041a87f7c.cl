//{"count":1,"in_data":8,"in_stride":6,"num_axis":7,"out_data":0,"out_shape":4,"out_stride":5,"scale":2,"shift":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_scale_stride_fwd(global float* out_data, const int count, const float scale, const float shift, global const int* out_shape, global const int* out_stride, global const int* in_stride, const int num_axis, global const float* in_data) {
  int global_idx = get_global_id(0);
  int in_offset = 0;
  int out_offset = 0;
  int valid_stride = 1;

  for (int i = num_axis - 1; i >= 0; --i) {
    int id = (global_idx / valid_stride) % out_shape[hook(4, i)];
    in_offset += id * in_stride[hook(6, i)];
    out_offset += id * out_stride[hook(5, i)];
    valid_stride *= out_shape[hook(4, i)];
  }

  out_data[hook(0, out_offset)] = in_data[hook(8, in_offset)] * scale + shift;
}