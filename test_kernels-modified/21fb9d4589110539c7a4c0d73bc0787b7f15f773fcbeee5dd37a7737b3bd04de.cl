//{"dt":3,"positions":0,"predictedPositions":1,"velocities":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void timestep(global const float3* positions, global float3* predictedPositions, global const float3* velocities, const float dt) {
  float3 velocity = velocities[hook(2, get_global_id(0))];
  velocity.y = velocity.y - dt * 9.82f;

  predictedPositions[hook(1, get_global_id(0))] = positions[hook(0, get_global_id(0))] + dt * velocity;
}