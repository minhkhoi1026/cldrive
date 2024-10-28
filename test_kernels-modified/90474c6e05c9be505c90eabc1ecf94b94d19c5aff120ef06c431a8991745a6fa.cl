//{"Nx":2,"NxNrm1":3,"fld_m_m1":0,"fld_m_p1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void get_m1(global double2* fld_m_m1, global double2* fld_m_p1, constant unsigned int* Nx, constant unsigned int* NxNrm1) {
  unsigned int i_grid = (unsigned int)get_global_id(0);
  if (i_grid < *NxNrm1) {
    unsigned int Nx_loc = *Nx;
    unsigned int ir = i_grid / Nx_loc;
    unsigned int ix = i_grid - ir * Nx_loc;

    unsigned int ix_orig = Nx_loc - ix;
    if (ix == 0) {
      ix_orig = 0;
    }

    unsigned int i_grid_orig = ix_orig + ir * Nx_loc;

    fld_m_m1[hook(0, i_grid)].s0 = -fld_m_p1[hook(1, i_grid_orig)].s0;
    fld_m_m1[hook(0, i_grid)].s1 = fld_m_p1[hook(1, i_grid_orig)].s1;
  }
}