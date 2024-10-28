//{"dt":0,"position_in":1,"position_out":3,"velocity_in":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float4 gravity = (float4)(0, 0, -10, 0);
kernel void integrate2Euler(float dt, global float4* position_in, global float4* velocity_in, global float4* position_out) {
  int id = get_global_id(0);

  position_out[hook(3, id)] = position_in[hook(1, id)] + dt * velocity_in[hook(2, id)];

  if ((position_out[hook(3, id)].z < -position_out[hook(3, id)].x * 0.3f)) {
    position_out[hook(3, id)].z = -position_out[hook(3, id)].x * 0.3f;
    velocity_in[hook(2, id)].z = 0.0f;
    velocity_in[hook(2, id)] *= 0.5f;
  }
  velocity_in[hook(2, id)] *= 0.999f;
}