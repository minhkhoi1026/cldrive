//{"Nx":5,"NxNr":4,"a":0,"b":1,"x":2,"z":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ab_dot_x(double2 a, global double* b, global double2* x, global double2* z, unsigned int NxNr, unsigned int Nx) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < NxNr) {
    unsigned int ir = i_cell / Nx;
    unsigned int ix = i_cell - ir * Nx;

    z[hook(3, i_cell)].s0 = b[hook(1, ix)] * (a.s0 * x[hook(2, i_cell)].s0 - a.s1 * x[hook(2, i_cell)].s1);
    z[hook(3, i_cell)].s1 = b[hook(1, ix)] * (a.s0 * x[hook(2, i_cell)].s1 + a.s1 * x[hook(2, i_cell)].s0);
  }
}