//{"N":3,"dt":2,"vx":1,"xp":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void move(global double* xp, global const double* vx, double dt, int N) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);

  while (gid < N) {
    xp[hook(0, gid)] += dt * vx[hook(1, gid)];
    gid += stride;
  }
}