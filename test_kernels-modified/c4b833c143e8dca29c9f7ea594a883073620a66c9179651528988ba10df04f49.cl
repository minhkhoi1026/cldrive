//{"mean_a":1,"mean_b":2,"p":0,"q":3,"scaling":5,"zero_out":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gf_q(global float4* p, global float4* mean_a, global float4* mean_b, global float4* q, int zero_out, float scaling) {
  int gX = get_global_id(0);

  float4 p_ = p[hook(0, gX)];
  float4 q_ = mean_a[hook(1, gX)] * p_ + mean_b[hook(2, gX)];

  int4 p_select = isequal(p_, 0.f) * zero_out;
  float4 q_z = select(q_, 0.f, p_select);

  q[hook(3, gX)] = scaling * q_z;
}