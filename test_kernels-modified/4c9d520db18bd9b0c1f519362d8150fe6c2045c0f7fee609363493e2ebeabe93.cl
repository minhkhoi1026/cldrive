//{"multiplier":3,"positions":0,"velocities":1,"vertex_count":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void linear_move(global float* positions, global float* velocities, int vertex_count, float multiplier) {
  int index = get_global_id(0) * 3;

  float4 this_velocity = (float4)(velocities[hook(1, index)], velocities[hook(1, index + 1)], velocities[hook(1, index + 2)], 0);

  positions[hook(0, index)] += this_velocity.x * multiplier;
  positions[hook(0, index + 1)] += this_velocity.y * multiplier;
  positions[hook(0, index + 2)] += this_velocity.z * multiplier;
}