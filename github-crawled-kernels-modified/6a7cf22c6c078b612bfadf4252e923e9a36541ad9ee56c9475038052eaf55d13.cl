//{"a":0,"di":1,"dj":2,"p":4,"pcf":3,"psi":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init1(double a, double di, double dj, double pcf, global double* p, global double* psi) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  psi[hook(5, y * (64 + 1) + x)] = a * sin((y + 0.5) * di) * sin((x + 0.5) * dj);
  p[hook(4, y * (64 + 1) + x)] = pcf * (cos(2.0 * y * di) + cos(2.0 * x * dj)) + 50000.0;
}