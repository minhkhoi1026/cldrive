//{"A_alphabetaB":2,"N":0,"sum":1,"xi_sum":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_update_xisum(const int N, const float sum, global const float* A_alphabetaB, global float* xi_sum) {
  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);
  size_t outID = gy * N + gx;
  xi_sum[hook(3, outID)] += A_alphabetaB[hook(2, outID)] / sum;
}