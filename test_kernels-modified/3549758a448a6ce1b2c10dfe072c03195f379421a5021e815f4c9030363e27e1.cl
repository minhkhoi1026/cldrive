//{"dt":7,"force1":3,"int2":5,"params":0,"pos0":1,"vel0":2,"vel1":4,"vel2":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void update(global float4* params, global float4* pos0, global float4* vel0, global float4* force1, global float4* vel1, global float4* int2, global float4* vel2, float dt) {
  int i = get_global_id(0);

  bool fixed = 0 < params[hook(0, i)].x;
  if (fixed) {
    return;
  }

  float mass = params[hook(0, i)].y;
  int2[hook(5, i)] = pos0[hook(1, i)] + vel1[hook(4, i)] * dt;
  vel2[hook(6, i)] = vel0[hook(2, i)] + force1[hook(3, i)] * dt / mass;
}