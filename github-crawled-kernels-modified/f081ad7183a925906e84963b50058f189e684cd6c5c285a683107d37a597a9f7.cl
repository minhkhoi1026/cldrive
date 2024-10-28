//{"dt":2,"positions":0,"velocities":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void taskParallelIntegrateVelocity(global float3* positions, global float3* velocities, const float dt) {
  int id = get_global_id(0);

  positions[hook(0, id)].x = positions[hook(0, id)].x + dt * velocities[hook(1, id)].x;
  positions[hook(0, id)].y = positions[hook(0, id)].y + dt * velocities[hook(1, id)].y;
  positions[hook(0, id)].z = positions[hook(0, id)].z + dt * velocities[hook(1, id)].z;
}