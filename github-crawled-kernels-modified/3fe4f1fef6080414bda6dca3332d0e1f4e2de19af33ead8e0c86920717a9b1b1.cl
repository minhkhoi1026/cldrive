//{"dt":13,"k1force":9,"k1vel":5,"k2force":10,"k2vel":6,"k3force":11,"k3vel":7,"k4force":12,"k4vel":8,"newpos":3,"newvel":4,"oldpos":1,"oldvel":2,"params":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void time_step(global float4* params, global float4* oldpos, global float4* oldvel, global float4* newpos, global float4* newvel, global float4* k1vel, global float4* k2vel, global float4* k3vel, global float4* k4vel, global float4* k1force, global float4* k2force, global float4* k3force, global float4* k4force, float dt) {
  int i = get_global_id(0);

  bool fixed = 0 < params[hook(0, i)].x;
  if (fixed) {
    return;
  }

  float mass = params[hook(0, i)].y;

  newpos[hook(3, i)] = oldpos[hook(1, i)] + dt / 6.0f * (k1vel[hook(5, i)] + 2.0f * k2vel[hook(6, i)] + 2.0f * k3vel[hook(7, i)] + k4vel[hook(8, i)]);

  newvel[hook(4, i)] = oldvel[hook(2, i)] + dt / (6.0f * mass) * (k1force[hook(9, i)] + 2.0f * k2force[hook(10, i)] + 2.0f * k3force[hook(11, i)] + k4force[hook(12, i)]);
}