//{"M_LEN":4,"N_LEN":5,"a":0,"di":1,"dj":2,"p":6,"pcf":3,"psi":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sw_init_psi_p(const double a, const double di, const double dj, const double pcf, const unsigned M_LEN, const unsigned N_LEN, global double* p, global double* psi) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < N_LEN && y < M_LEN) {
    psi[hook(7, y * M_LEN + x)] = a * sin((x + .5) * di) * sin((y + .5) * dj);
    p[hook(6, y * M_LEN + x)] = pcf * (cos(2. * (x)*di) + cos(2. * (y)*dj)) + 50000.;
  }
}