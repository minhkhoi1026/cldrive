//{"M_LEN":3,"cu":4,"cv":5,"h":7,"p_curr":10,"p_next":13,"tdts8":0,"tdtsdx":1,"tdtsdy":2,"u_curr":8,"u_next":11,"v_curr":9,"v_next":12,"z":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sw_compute1(const double tdts8, const double tdtsdx, const double tdtsdy, const unsigned M_LEN, global const double* cu, global const double* cv, global const double* z, global const double* h, global const double* u_curr, global const double* v_curr, global const double* p_curr, global double* u_next, global double* v_next, global double* p_next) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  u_next[hook(11, (y + 1) * M_LEN + x)] = u_curr[hook(8, (y + 1) * M_LEN + x)] + tdts8 * (z[hook(6, (y + 1) * M_LEN + x + 1)] + z[hook(6, (y + 1) * M_LEN + x)]) * (cv[hook(5, (y + 1) * M_LEN + x + 1)] + cv[hook(5, y * M_LEN + x + 1)] + cv[hook(5, y * M_LEN + x)] + cv[hook(5, (y + 1) * M_LEN + x)]) - tdtsdx * (h[hook(7, (y + 1) * M_LEN + x)] - h[hook(7, y * M_LEN + x)]);

  v_next[hook(12, y * M_LEN + x + 1)] = v_curr[hook(9, y * M_LEN + x + 1)] - tdts8 * (z[hook(6, (y + 1) * M_LEN + x + 1)] + z[hook(6, y * M_LEN + x + 1)]) * (cu[hook(4, (y + 1) * M_LEN + x + 1)] + cu[hook(4, y * M_LEN + x + 1)] + cu[hook(4, y * M_LEN + x)] + cu[hook(4, y * M_LEN + x + 1)]) - tdtsdy * (h[hook(7, y * M_LEN + x + 1)] - h[hook(7, y * M_LEN + x)]);

  p_next[hook(13, y * M_LEN + x)] = p_curr[hook(10, y * M_LEN + x)] - tdtsdx * (cu[hook(4, (y + 1) * M_LEN + x)] - cu[hook(4, y * M_LEN + x)]) - tdtsdy * (cv[hook(5, y * M_LEN + x + 1)] - cv[hook(5, y * M_LEN + x)]);
}