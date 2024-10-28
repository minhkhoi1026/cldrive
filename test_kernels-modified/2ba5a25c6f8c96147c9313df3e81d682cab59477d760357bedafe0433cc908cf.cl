//{"a":2,"b":3,"eps":4,"mean_p":0,"mean_p2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gf_ab(global float4* mean_p, global float4* mean_p2, global float4* a, global float4* b, float eps) {
  int gX = get_global_id(0);

  float4 m_p = mean_p[hook(0, gX)];
  float4 var_p = mean_p2[hook(1, gX)] - pown(m_p, 2);
  float4 a_ = var_p / (var_p + eps);

  a[hook(2, gX)] = a_;
  b[hook(3, gX)] = (1.f - a_) * m_p;
}