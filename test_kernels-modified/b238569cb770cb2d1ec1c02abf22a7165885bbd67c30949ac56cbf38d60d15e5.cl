//{"count":4,"in_data_a":2,"in_data_b":3,"out_data":0,"with_relu":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_elt_max_f4(global float* out_data, const int with_relu, global const float* in_data_a, global const float* in_data_b, int count) {
  int idx = get_global_id(0);
  float4 tmp1, tmp2;
  global float4* vdst;

  if (idx < count) {
    tmp1 = (global const float4)(in_data_a[hook(2, idx)]);
    tmp2 = (global const float4)(in_data_b[hook(3, idx)]);

    tmp1.x = tmp1.x > tmp2.x ? tmp1.x : tmp2.x;
    tmp1.y = tmp1.y > tmp2.y ? tmp1.y : tmp2.y;
    tmp1.z = tmp1.z > tmp2.z ? tmp1.z : tmp2.z;
    tmp1.w = tmp1.w > tmp2.w ? tmp1.w : tmp2.w;

    vdst = (global float4*)(&out_data[hook(0, idx)]);
    *vdst = tmp1;
  }
}