//{"N":2,"in":0,"negative_slope":3,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ReLUForward(global float* in, global float* out, int N, float negative_slope) {
  for (int index = get_group_id(0) * get_local_size(0) + get_local_id(0); index < (N); index += get_num_groups(0) * get_local_size(0)) {
    out[hook(1, index)] = in[hook(0, index)] > 0 ? in[hook(0, index)] : in[hook(0, index)] * negative_slope;
  }
}