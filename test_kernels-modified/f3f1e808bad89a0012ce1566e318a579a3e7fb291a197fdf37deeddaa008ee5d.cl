//{"a":4,"b":5,"buf_in":6,"buf_out":7,"ix_buf":9,"l":8,"p":1,"p_d1":2,"p_p1":0,"pos":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lrs_2(global float* p_p1, const global float* p, const global float* p_d1, const global unsigned* pos, const constant float* a, const constant float* b, global float* buf_in, global float* buf_out, const float l, const unsigned ix_buf) {
  unsigned id = get_global_id(0);

  const unsigned x = (unsigned)pos[hook(3, ((id) * 5 + (0)))];
  const unsigned y = (unsigned)pos[hook(3, ((id) * 5 + (1)))];
  const unsigned z = (unsigned)pos[hook(3, ((id) * 5 + (2)))];
  const unsigned ix_mat_0 = (unsigned)pos[hook(3, ((id) * 5 + (3)))];
  const unsigned ix_mat_1 = (unsigned)pos[hook(3, ((id) * 5 + (4)))];

  const unsigned size_f = 8 / 2;

  const float a0_0 = a[hook(4, ((ix_mat_0) * 4 + (0)))];
  const float a0_1 = a[hook(4, ((ix_mat_1) * 4 + (0)))];
  const float b0_0 = b[hook(5, ((ix_mat_0) * 4 + (0)))];
  const float b0_1 = b[hook(5, ((ix_mat_1) * 4 + (0)))];

  float gn_0 = 0.0f;
  float gn_1 = 0.0f;

  for (unsigned i = 1; i < 4; ++i) {
    gn_0 += b[hook(5, ((ix_mat_0) * 4 + (i)))] * buf_in[hook(6, ((id) * 8 + ((ix_buf + i) % size_f)))] - a[hook(4, ((ix_mat_0) * 4 + (i)))] * buf_out[hook(7, ((id) * 8 + ((ix_buf + i) % size_f)))];

    gn_1 += b[hook(5, ((ix_mat_1) * 4 + (i)))] * buf_in[hook(6, ((id) * 8 + ((ix_buf + i) % size_f + size_f)))] - a[hook(4, ((ix_mat_1) * 4 + (i)))] * buf_out[hook(7, ((id) * 8 + ((ix_buf + i) % size_f + size_f)))];
  }

  const float l2 = l * l;
  const float xn_0 = a0_0 / (l * b0_0) * (p_p1[hook(0, ((z) * 128 * 256 + (y) * 256 + (x)))] - p_d1[hook(2, ((z) * 128 * 256 + (y) * 256 + (x)))]) - gn_0 / b0_0;
  buf_in[hook(6, ((id) * 8 + (ix_buf)))] = xn_0;
  buf_out[hook(7, ((id) * 8 + (ix_buf)))] = 1.0f / a0_0 * (b0_0 * xn_0 + gn_0);

  const float xn_1 = a0_1 / (l * b0_1) * (p_p1[hook(0, ((z) * 128 * 256 + (y) * 256 + (x)))] - p_d1[hook(2, ((z) * 128 * 256 + (y) * 256 + (x)))]) - gn_1 / b0_1;
  buf_in[hook(6, ((id) * 8 + (ix_buf + size_f)))] = xn_1;
  buf_out[hook(7, ((id) * 8 + (ix_buf + size_f)))] = 1 / a0_1 * (b0_1 * xn_1 + gn_1);
}