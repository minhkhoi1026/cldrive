//{"N":0,"sum":1,"xi_sum":3,"xi_sum_tmp":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_update_xisum(const int N, const float sum, global const float* xi_sum_tmp, global float* xi_sum) {
  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);

  if (gx < N && gy < N) {
    size_t index = gy * N + gx;
    xi_sum[hook(3, index)] += xi_sum_tmp[hook(2, index)] / sum;
  }
}