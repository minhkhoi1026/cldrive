//{"a":4,"b":5,"cov_Ip":1,"eps":6,"mean_I":2,"mean_p":3,"var_I":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gf_ab_Ip(global float4* var_I, global float4* cov_Ip, global float4* mean_I, global float4* mean_p, global float4* a, global float4* b, float eps) {
  int gX = get_global_id(0);

  float4 a_ = cov_Ip[hook(1, gX)] / (var_I[hook(0, gX)] + eps);

  a[hook(4, gX)] = a_;
  b[hook(5, gX)] = mean_p[hook(3, gX)] - a_ * mean_I[hook(2, gX)];
}