//{"L":2,"N":1,"xp":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalize_particles(global double* xp, int N, double L) {
  int gid = get_global_id(0);
  const int stride = get_global_size(0);
  while (gid < N) {
    if (xp[hook(0, gid)] < 0)
      xp[hook(0, gid)] += L;
    if (xp[hook(0, gid)] >= L)
      xp[hook(0, gid)] -= L;
    gid += stride;
  }
}