//{"count":1,"in_data":4,"out_data":0,"scale":2,"shift":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_scale_fwd(global float* out_data, const int count, const float scale, const float shift, global const float* in_data) {
  int global_idx = get_global_id(0);
  out_data[hook(0, global_idx)] = in_data[hook(4, global_idx)] * scale + shift;
}