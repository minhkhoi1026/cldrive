//{"bias_data":3,"bias_flag":7,"count":4,"in_data":1,"inner_dim":6,"out_data":0,"scale_data":2,"scale_dim":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Scale_multiBias(global float* out_data, global float* in_data, global float* scale_data, global float* bias_data, const int count, const int scale_dim, const int inner_dim, const int bias_flag) {
  int tid = get_global_id(0);

  if (tid < count) {
    int scale_id = (tid / inner_dim) % scale_dim;
    float scale = scale_data[hook(2, scale_id)];
    out_data[hook(0, tid)] = (bias_flag == 1) ? scale * in_data[hook(1, tid)] + bias_data[hook(3, scale_id)] : scale * in_data[hook(1, tid)];
  }
}