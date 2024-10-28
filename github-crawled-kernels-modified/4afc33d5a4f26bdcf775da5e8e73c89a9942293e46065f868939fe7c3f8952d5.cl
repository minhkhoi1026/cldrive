//{"coeff1":4,"coeff2":5,"count":6,"in_data1":2,"in_data2":3,"out_data":0,"with_relu":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ker_elt_sum(global float* out_data, const int with_relu, global const float* in_data1, global const float* in_data2, float coeff1, float coeff2, int count) {
  int idx = get_global_id(0);

  if (idx < count) {
    float tmp = coeff1 * in_data1[hook(2, idx)] + coeff2 * in_data2[hook(3, idx)];

    out_data[hook(0, idx)] = tmp;
  }
}