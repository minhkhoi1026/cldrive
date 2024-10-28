//{"N":0,"gas_stiffness":3,"particle_mass":1,"pdensity":8,"ppressure":9,"px":5,"py":6,"pz":7,"radius":2,"rest_density":4,"xmax":13,"xmin":10,"ymax":14,"ymin":11,"zmax":15,"zmin":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float default_kernel(const float dx, const float dy, const float dz, const float h) {
  float cudiff = h * h - (dx * dx + dy * dy + dz * dz);
  if (cudiff < 0)
    return 0.0;
  return 35.0f / 32.0f / (h * h * h * h * h * h * h) * cudiff * cudiff * cudiff;
}

float spiky_kernel(const float dx, const float dy, const float dz, const float h) {
  float d2 = (dx * dx + dy * dy + dz * dz);
  if (h * h < d2)
    return 0.0f;
  float diff = h - sqrt(d2);
  return diff * diff * diff * 0.25f / (h * h * h * h);
}

kernel void update_quantities(const unsigned int N, const float particle_mass, const float radius, const float gas_stiffness, const float rest_density, global float* px, global float* py, global float* pz, global float* pdensity, global float* ppressure, float xmin, float ymin, float zmin, float xmax, float ymax, float zmax) {
  const int globalid = get_global_id(0);
  if (globalid >= N)
    return;

  pdensity[hook(8, globalid)] = 0;
  ppressure[hook(9, globalid)] = 0;

  for (unsigned int i = 0; i < N; i++) {
    float dx = px[hook(5, globalid)] - px[hook(5, i)];
    float dy = py[hook(6, globalid)] - py[hook(6, i)];
    float dz = pz[hook(7, globalid)] - pz[hook(7, i)];

    float partial_density = default_kernel(dx, dy, dz, radius);
    pdensity[hook(8, globalid)] += partial_density * particle_mass;

    if (i != globalid) {
      ppressure[hook(9, globalid)] += spiky_kernel(dy, dy, dz, radius) * particle_mass;
    }
  }

  ppressure[hook(9, globalid)] = (ppressure[hook(9, globalid)] - rest_density) * gas_stiffness;
}