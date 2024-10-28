//{"a":0,"b":1,"c":2,"common_dim":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sgemm(global float* a, global float* b, global float* c, unsigned int common_dim) {
  unsigned int k, xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);
  unsigned int xgsize = get_global_size(0);

  float c_ = c[hook(2, xgid + ygid * xgsize)];

  for (k = 0; k < common_dim; ++k)
    c_ += a[hook(0, k + ygid * common_dim)] * b[hook(1, xgid + k * xgsize)];

  c[hook(2, xgid + ygid * xgsize)] = c_;
}