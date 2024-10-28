//{"corr_I":0,"corr_Ip":1,"cov_Ip":5,"mean_I":2,"mean_p":3,"var_I":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gf_var_Ip(global float4* corr_I, global float4* corr_Ip, global float4* mean_I, global float4* mean_p, global float4* var_I, global float4* cov_Ip) {
  int gX = get_global_id(0);

  float4 m_I = mean_I[hook(2, gX)];

  var_I[hook(4, gX)] = corr_I[hook(0, gX)] - m_I * m_I;
  cov_Ip[hook(5, gX)] = corr_Ip[hook(1, gX)] - m_I * mean_p[hook(3, gX)];
}