//{"dt":7,"g_inv":6,"num_p":8,"px":3,"py":4,"pz":5,"x":0,"y":1,"z":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void push_xyz(global double* x, global double* y, global double* z, global double* px, global double* py, global double* pz, global double* g_inv, constant double* dt, constant unsigned int* num_p) {
  unsigned int ip = (unsigned int)get_global_id(0);
  if (ip < *num_p) {
    double dt_g = (*dt) * g_inv[hook(6, ip)];

    double dx = px[hook(3, ip)] * dt_g;
    double dy = py[hook(4, ip)] * dt_g;
    double dz = pz[hook(5, ip)] * dt_g;

    x[hook(0, ip)] = x[hook(0, ip)] + dx;
    y[hook(1, ip)] = y[hook(1, ip)] + dy;
    z[hook(2, ip)] = z[hook(2, ip)] + dz;
  }
}