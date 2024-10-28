//{"in_data":1,"in_slice_axis_size":4,"nthreads":0,"num_slices":2,"offset_slice_axis":6,"out_data":7,"out_slice_axis_size":5,"slice_size":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(512, 1, 1))) __attribute__((reqd_work_group_size(512, 1, 1))) kernel void Slice_normal_512_f4(const int nthreads, global const float* in_data, const int num_slices, const int slice_size, const int in_slice_axis_size, const int out_slice_axis_size, const int offset_slice_axis, global float* out_data) {
  int index = get_global_id(0);
  global float4* vsrc;
  global float4* vdst;
  if (index < nthreads) {
    const int total_slice_size = slice_size * out_slice_axis_size;
    const int slice_num = index / (total_slice_size >> 2);
    int slice_index = index % (total_slice_size >> 2);
    int top_index = index << 2;
    int bottom_index = ((slice_num * in_slice_axis_size + offset_slice_axis) * slice_size);
    vsrc = (global float4*)(&in_data[hook(1, bottom_index + slice_index * 4)]);
    vdst = (global float4*)(&out_data[hook(7, top_index)]);
    *vdst = *vsrc;
  }
}