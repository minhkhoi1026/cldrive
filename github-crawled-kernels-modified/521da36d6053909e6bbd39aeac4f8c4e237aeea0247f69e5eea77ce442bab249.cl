//{"coeff1":4,"coeff2":5,"count":6,"in_data1":2,"in_data2":3,"out_data":0,"with_relu":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_elt_sum_f4(global float* out_data, const int with_relu, global const float* in_data1, global const float* in_data2, float coeff1, float coeff2, int count) {
  float4 tmp1, tmp2, tmp3;
  global float4* vdst;

  int idx = get_global_id(0);

  if (idx < count) {
    tmp1 = *((global const float4*)(&in_data1[hook(2, idx * 4)]));
    tmp2 = *((global const float4*)(&in_data2[hook(3, idx * 4)]));
    tmp3.x = coeff1 * tmp1.x + coeff2 * tmp2.x;
    tmp3.y = coeff1 * tmp1.y + coeff2 * tmp2.y;
    tmp3.z = coeff1 * tmp1.z + coeff2 * tmp2.z;
    tmp3.w = coeff1 * tmp1.w + coeff2 * tmp2.w;

    vdst = (global float4*)(&out_data[hook(0, idx * 4)]);
    *vdst = tmp3;
  }
}