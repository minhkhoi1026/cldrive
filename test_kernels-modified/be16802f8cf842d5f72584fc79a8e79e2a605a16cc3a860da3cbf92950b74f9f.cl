//{"Ep":0,"N":4,"dt":3,"q":1,"vx":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void accel(global double* Ep, global const double* q, global double* vx, double dt, int N) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);

  while (gid < N) {
    vx[hook(2, gid)] += dt * Ep[hook(0, gid)];
    gid += stride;
  }
}