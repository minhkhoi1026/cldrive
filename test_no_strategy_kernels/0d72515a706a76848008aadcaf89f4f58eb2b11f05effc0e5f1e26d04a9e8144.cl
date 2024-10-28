//{"densities":3,"howMany":5,"kernelSize":4,"mass":6,"positions":1,"velocities":2,"viscosityConstant":7,"viscosityForces":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void taskParallelCalculateViscosityForce(global float3* viscosityForces, global float3* positions, global float3* velocities, global float* densities, const float kernelSize, const int howMany, const float mass, const float viscosityConstant) {
  int id = get_global_id(0);
  float3 r;
  float pi = 3.14;

  for (int i = 0; i < howMany; i++) {
    r.x = positions[hook(1, id)].x - positions[hook(1, i)].x;
    r.y = positions[hook(1, id)].y - positions[hook(1, i)].y;
    r.z = positions[hook(1, id)].z - positions[hook(1, i)].z;

    float radius = sqrt(r.x * r.x + r.y * r.y + r.z * r.z);

    if (radius < kernelSize) {
      viscosityForces[hook(0, id)].x = viscosityForces[hook(0, id)].x + mass * ((velocities[hook(2, i)].x - velocities[hook(2, id)].x) / densities[hook(3, i)]) * (45 / (pi * pown(kernelSize, 6))) * (kernelSize - radius);
      viscosityForces[hook(0, id)].y = viscosityForces[hook(0, id)].y + mass * ((velocities[hook(2, i)].y - velocities[hook(2, id)].y) / densities[hook(3, i)]) * (45 / (pi * pown(kernelSize, 6))) * (kernelSize - radius);
      viscosityForces[hook(0, id)].z = viscosityForces[hook(0, id)].z + mass * ((velocities[hook(2, i)].z - velocities[hook(2, id)].z) / densities[hook(3, i)]) * (45 / (pi * pown(kernelSize, 6))) * (kernelSize - radius);
    }
  }
}