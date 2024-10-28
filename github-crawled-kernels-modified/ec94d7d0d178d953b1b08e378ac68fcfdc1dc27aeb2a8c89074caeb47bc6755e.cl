//{"M":0,"M_LEN":2,"N":1,"alpha":3,"p":6,"p_curr":9,"p_next":12,"u":4,"u_curr":7,"u_next":10,"v":5,"v_curr":8,"v_next":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sw_time_smooth(const unsigned M, const unsigned N, const unsigned M_LEN, const double alpha, global double* u, global double* v, global double* p, global double* u_curr, global double* v_curr, global double* p_curr, global double* u_next, global double* v_next, global double* p_next) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  u_curr[hook(7, y * M_LEN + x)] = u[hook(4, y * M_LEN)] + alpha * (u_next[hook(10, y * M_LEN + x)] - 2. * u[hook(4, y * M_LEN + x)] + u_curr[hook(7, y * M_LEN + x)]);
  v_curr[hook(8, y * M_LEN + x)] = v[hook(5, y * M_LEN)] + alpha * (v_next[hook(11, y * M_LEN + x)] - 2. * v[hook(5, y * M_LEN + x)] + v_curr[hook(8, y * M_LEN + x)]);
  p_curr[hook(9, y * M_LEN + x)] = p[hook(6, y * M_LEN)] + alpha * (p_next[hook(12, y * M_LEN + x)] - 2. * p[hook(6, y * M_LEN + x)] + p_curr[hook(9, y * M_LEN + x)]);
}