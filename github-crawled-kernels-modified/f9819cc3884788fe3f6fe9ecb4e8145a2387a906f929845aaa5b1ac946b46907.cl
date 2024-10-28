//{"dt":0,"force_in":3,"invmass_in":1,"velocity_in":2,"velocity_out":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float4 gravity = (float4)(0, 0, -10, 0);
kernel void integrate1Euler(float dt, global float* invmass_in, global float4* velocity_in, global float4* force_in, global float4* velocity_out) {
  int id = get_global_id(0);
  velocity_out[hook(4, id)] = velocity_in[hook(2, id)] + dt * force_in[hook(3, id)] * invmass_in[hook(1, id)];
}