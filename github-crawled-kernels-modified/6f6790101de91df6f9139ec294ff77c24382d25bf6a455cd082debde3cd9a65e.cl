//{"Lx":1,"Nx":2,"kx":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void frequencies(global double* kx, const double Lx, const int Nx) {
  const int ind = get_global_id(0);
  if (ind < Nx / 2)
    kx[hook(0, ind)] = -1.0 * ((double)((ind)) / Lx) * ((double)(ind) / Lx);
  if (ind == Nx / 2)
    kx[hook(0, ind)] = 0.0;
  if (ind > Nx / 2)
    kx[hook(0, ind)] = -1.0 * (double)(Nx - ind) / Lx * (double)(Nx - ind) / Lx;
}