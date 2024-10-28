//{"force":1,"newpos":4,"newvel":5,"oldpos":2,"oldvel":3,"params":0,"time":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void time_step(global float4* params, global float4* force, global float4* oldpos, global float4* oldvel, global float4* newpos, global float4* newvel, float time) {
  int i = get_global_id(0);

  bool fixed = 0 < params[hook(0, i)].x;
  if (fixed) {
    return;
  }

  float mass = params[hook(0, i)].y;
  float4 acc = force[hook(1, i)] / mass;
  float halftt = 0.5 * time * time;
  newpos[hook(4, i)] = oldpos[hook(2, i)] + oldvel[hook(3, i)] / time + acc * halftt;
  newvel[hook(5, i)] = oldvel[hook(3, i)] + acc / time;
}