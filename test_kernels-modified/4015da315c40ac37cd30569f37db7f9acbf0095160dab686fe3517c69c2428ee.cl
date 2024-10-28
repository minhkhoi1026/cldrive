//{"energies":2,"position":0,"velocity":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double2 when_eq(double2 x, double2 y) {
  return 1.0f - fabs(sign(x - y));
}
double when_neq(double x, double y) {
  return fabs(sign(x - y));
}

double2 when_gt(double2 x, double2 y) {
  return max(sign(x - y), 0.0);
}

double2 when_lt(double2 x, double2 y) {
  return min(1.0f - sign(x - y), 1.0f);
}

double2 when_ge(double2 x, double2 y) {
  return 1.0f - when_lt(x, y);
}

double2 when_le(double2 x, double2 y) {
  return 1.0f - when_gt(x, y);
}

double2 wrap(double2 vec) {
  double2 diff = when_gt(fabs(vec), 1.0);
  return -sign(vec) * 2.0 * diff + vec;
}

double3 calculateForcePotential(double2 p0, double2 p1) {
  double2 delta = 2.5e1 * wrap(p0 - p1);

  double diff = when_neq(length(delta), 0.0);
  double inv = rsqrt(dot(delta, delta) + 0.7);
  double r_2 = 1 * inv;
  r_2 *= r_2;
  double r_6 = r_2 * r_2 * r_2;
  double r_12 = r_6 * r_6;
  return diff * (double3)(48.0 * 1 * inv * inv * (r_12 - 0.5 * r_6) * delta, 4.0 * 1 * (r_12 - r_6));
}

double3 calculateForcePotential2(double2 p0, double2 p1) {
  double2 delta = 2.5e1 * wrap(p1 - p0);
  double diff = when_neq(length(delta), 0.0);
  double inv = rsqrt(dot(delta, delta) + 1);
  return diff * (double3)(delta * inv * inv * inv, -inv);
}

kernel void naive_update_velocity(global double2* position, global double2* velocity, global double2* energies) {
  int id = get_global_id(0);
  double2 base = position[hook(0, id)];
  double2 base_vel = velocity[hook(1, id)];

  double3 total_force = 0.0f;
  int N = get_global_size(0);
  for (int i = 0; i < N; i++)
    total_force += calculateForcePotential(base, position[hook(0, i)]);
  base_vel = base_vel + total_force.xy * 0.001;
  velocity[hook(1, id)] = base_vel;
  energies[hook(2, id)] = 0.5 * (double2)(total_force.z, 2.5e1 * dot(base_vel, base_vel));
}