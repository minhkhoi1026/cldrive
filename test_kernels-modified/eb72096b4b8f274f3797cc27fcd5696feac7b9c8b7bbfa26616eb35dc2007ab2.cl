//{"a":3,"b":4,"buf_in":5,"buf_out":6,"gn_array":7,"ix_buf":9,"l":8,"p":0,"p_d1":1,"pos":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lrs_ghost(global float* p, const global float* p_d1, const global unsigned* pos, const global float* a, const global float* b, const global float* buf_in, const global float* buf_out, global float* gn_array, const float l, const unsigned ix_buf) {
  const unsigned id = get_global_id(0);

  const unsigned x = pos[hook(2, ((id) * 4 + (0)))];
  const unsigned y = pos[hook(2, ((id) * 4 + (1)))];
  const unsigned z = pos[hook(2, ((id) * 4 + (2)))];
  const unsigned ix_mat = pos[hook(2, ((id) * 4 + (3)))];

  const float l2 = l * l;
  const float a0 = a[hook(3, ((ix_mat) * 4 + (0)))];
  const float b0 = a[hook(3, ((ix_mat) * 4 + (0)))];

  float gn = 0.0f;

  for (unsigned i = 1; i < 4; ++i) {
    gn += b[hook(4, ((ix_mat) * 4 + (i)))] * buf_in[hook(5, ((id) * 3 + ((ix_buf + i) % 3)))] - a[hook(3, ((ix_mat) * 4 + (i)))] * buf_out[hook(6, ((id) * 3 + ((ix_buf + i) % 3)))];
  }

  gn_array[hook(7, id)] = gn;
}