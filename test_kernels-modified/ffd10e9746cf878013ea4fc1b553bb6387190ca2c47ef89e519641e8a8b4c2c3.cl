//{"a":4,"b":5,"buf_in":6,"buf_out":7,"ix_buf":9,"l":8,"p":1,"p_d1":2,"p_p1":0,"pos":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lrs_1(global float* p_p1, const global float* p, const global float* p_d1, const global unsigned* pos, const constant float* a, const constant float* b, global float* buf_in, global float* buf_out, const float l, const unsigned ix_buf) {
  unsigned id = get_global_id(0);

  const unsigned x = pos[hook(3, ((id) * 4 + (0)))];
  const unsigned y = pos[hook(3, ((id) * 4 + (1)))];
  const unsigned z = pos[hook(3, ((id) * 4 + (2)))];
  const unsigned ix_mat = pos[hook(3, ((id) * 4 + (3)))];

  const float a0 = a[hook(4, ((ix_mat) * 4 + (0)))];
  const float b0 = b[hook(5, ((ix_mat) * 4 + (0)))];

  float gn = 0.0f;

  for (unsigned i = 1; i < 4; ++i) {
    gn += b[hook(5, ((ix_mat) * 4 + (i)))] * buf_in[hook(6, ((id) * 4 + ((ix_buf + i) % 4)))] - a[hook(4, ((ix_mat) * 4 + (i)))] * buf_out[hook(7, ((id) * 4 + ((ix_buf + i) % 4)))];
  }

  const float l2 = l * l;
  const float xn = a0 / (l * b0) * (p_p1[hook(0, ((z) * 128 * 256 + (y) * 256 + (x)))] - p_d1[hook(2, ((z) * 128 * 256 + (y) * 256 + (x)))]) - gn / b0;
  buf_in[hook(6, ((id) * 4 + (ix_buf)))] = xn;
  buf_out[hook(7, ((id) * 4 + (ix_buf)))] = 1.0f / a0 * (b0 * xn + gn);
}