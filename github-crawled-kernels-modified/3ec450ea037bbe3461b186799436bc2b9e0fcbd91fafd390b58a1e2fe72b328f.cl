//{"dst":4,"nthreads":0,"offset":1,"variance":3,"variance_size":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_variance(const int nthreads, const int offset, const int variance_size, global const float* variance, global float* dst) {
  for (int index = get_global_id(0); index < nthreads; index += get_global_size(0)) {
    float4 var_vec;

    if (variance_size == 1)
      var_vec = (float4)(variance[hook(3, 0)]);
    else
      var_vec = vload4(0, variance);

    vstore4(var_vec, 0, dst + offset + index * 4);
  }
}