//{"num_values":2,"result":1,"result_tmp":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scalar_product_real_reduction(global float* result_tmp, global float* result, const unsigned int num_values) {
  int id = get_global_id(0);
  if (id == 0) {
    float tmp = result_tmp[hook(0, 0)];
    for (int i = 1; i < num_values; i++) {
      tmp += result_tmp[hook(0, i)];
    }
    (*result) = tmp;
  }
}