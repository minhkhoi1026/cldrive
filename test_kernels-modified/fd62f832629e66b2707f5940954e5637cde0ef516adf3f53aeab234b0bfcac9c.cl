//{"N":4,"deltaVelocities":3,"positions":0,"predicted":1,"velocities":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void updatePositions(global float4* positions, const global float4* predicted, global float4* velocities, const global float4* deltaVelocities, const unsigned int N) {
  const unsigned int i = get_global_id(0);
  if (i >= N)
    return;

  positions[hook(0, i)].xyz = predicted[hook(1, i)].xyz;
  velocities[hook(2, i)].xyz += deltaVelocities[hook(3, i)].xyz;

  positions[hook(0, i)].w = length(velocities[hook(2, i)].xyz);
}