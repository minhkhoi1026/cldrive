//{"count":1,"in_data":5,"out_data":0,"power":4,"scale":2,"shift":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_power_fwd_f4(global float* out_data, const int count, const float scale, const float shift, const float power, global const float* in_data) {
  int global_idx = get_global_id(0);

  global float4* vsrc;
  global float4* vdst;
  float4 in_data_private;
  vsrc = (global float4*)(&in_data[hook(5, global_idx * 4)]);
  in_data_private = pow((*vsrc) * scale + shift, power);
  vdst = (global float4*)(&out_data[hook(0, global_idx * 4)]);
  *vdst = in_data_private;
}