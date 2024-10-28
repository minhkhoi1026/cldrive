//{"Nx":3,"kx":1,"phs_shft":0,"x0":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void get_phase_minus(global double2* phs_shft, global double* kx, double x0, unsigned int Nx) {
  unsigned int ix = (unsigned int)get_global_id(0);
  if (ix < Nx) {
    phs_shft[hook(0, ix)].s0 = cos(x0 * kx[hook(1, ix)]);
    phs_shft[hook(0, ix)].s1 = -sin(x0 * kx[hook(1, ix)]);
  }
}