//{"Nf":4,"Nx":3,"NxNr":2,"f":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void profile_edges_d(global double* x, global double* f, unsigned int NxNr, unsigned int Nx, unsigned int Nf) {
  unsigned int i_cell = (unsigned int)get_global_id(0);
  if (i_cell < NxNr) {
    unsigned int ir = i_cell / Nx;
    unsigned int ix = i_cell - ir * Nx;
    if (ix < Nf) {
      x[hook(0, i_cell)] *= f[hook(1, ix)];
    }

    if (ix > Nx - Nf) {
      x[hook(0, i_cell)] *= f[hook(1, Nx - ix)];
    }
  }
}