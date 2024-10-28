//{"dt":3,"length":2,"npos":0,"nvel":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double norm(double4 r) {
  return sqrt(r.x * r.x + r.y * r.y + r.z * r.z);
}

double4 Fg(double m1, double m2, double4 pos1, double4 int2) {
  double4 dr;

  dr = int2 - pos1;
  return dr * 6.674 * pow(10., -11) * m1 * m2 / pow(norm(dr), 3);
}

kernel void drift(global double4* npos, global double4* nvel, int length, float dt) {
  int index = get_global_id(1);

  if (index < length) {
    npos[hook(0, index)] += nvel[hook(1, index)] * dt;
  }
}