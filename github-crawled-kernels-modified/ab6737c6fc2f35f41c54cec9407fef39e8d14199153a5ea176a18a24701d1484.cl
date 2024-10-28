//{"N":0,"fx":10,"fy":11,"fz":12,"ofx":13,"ofy":14,"ofz":15,"particle_mass":1,"pdensity":16,"ppressure":17,"px":4,"py":5,"pz":6,"radius":2,"viscosity":3,"vx":7,"vy":8,"vz":9,"xmax":21,"xmin":18,"ymax":22,"ymin":19,"zmax":23,"zmin":20}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float3 spiky_gradient_kernel(const float3 distance, const float h) {
  float d = length(distance);

  float diff = h - d;
  if (diff < 0)
    return 0.0;
  if (d <= 0.00000001)
    return 0.0;
  float factor = 1.0 / d * diff * diff / (13.0 / 6.0 * (h * h * h));
  return distance * factor;
}

float viscosity_kernel(const float3 distance, const float h) {
  float diff = h - length(distance);
  if (diff < 0)
    return 0;
  return 45.0 / 3.14159265358979323846f / (h * h * h * h * h * h) * diff;
}

kernel void update_forces(const unsigned int N, const float particle_mass, const float radius, const float viscosity, global float* px, global float* py, global float* pz, global float* vx, global float* vy, global float* vz, global float* fx, global float* fy, global float* fz, global float* ofx, global float* ofy, global float* ofz, global float* pdensity, global float* ppressure, float xmin, float ymin, float zmin, float xmax, float ymax, float zmax) {
  const int globalid = get_global_id(0);
  if (globalid >= N)
    return;

  float3 new_force = 0.0f;

  for (unsigned int i = 0; i < N; i++) {
    if (i != globalid) {
      float3 distance = {px[hook(4, globalid)] - px[hook(4, i)], py[hook(5, globalid)] - py[hook(5, i)], pz[hook(6, globalid)] - pz[hook(6, i)]};

      float3 pgrad = spiky_gradient_kernel(distance, radius);
      float factor = (ppressure[hook(17, globalid)] + ppressure[hook(17, i)]) * 0.5 * particle_mass / pdensity[hook(16, i)];
      new_force += pgrad * factor;

      float3 dv = (float3)(vx[hook(7, i)] - vx[hook(7, globalid)], vy[hook(8, i)] - vy[hook(8, globalid)], vz[hook(9, i)] - vz[hook(9, globalid)]);

      new_force += dv * particle_mass / pdensity[hook(16, i)] * viscosity_kernel(distance, radius) * viscosity;
    }
  }

  new_force.y -= 100.0 * particle_mass;

  ofx[hook(13, globalid)] = fx[hook(10, globalid)];
  ofy[hook(14, globalid)] = fy[hook(11, globalid)];
  ofz[hook(15, globalid)] = fz[hook(12, globalid)];

  fx[hook(10, globalid)] = new_force.x;
  fy[hook(11, globalid)] = new_force.y;
  fz[hook(12, globalid)] = new_force.z;
}