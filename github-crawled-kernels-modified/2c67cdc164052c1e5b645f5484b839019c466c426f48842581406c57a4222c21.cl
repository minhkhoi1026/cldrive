//{"buf":0,"dt":2,"info":3,"t":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void updateParticles(global float* buf, float t, float dt, global float* info) {
  int idx = get_global_id(0) * 2;
  if (t < 0.000001f) {
    buf[hook(0, idx)] = -1.0f;
    buf[hook(0, idx + 1)] = -1.0f;
  } else {
    float2 dir = (float2)(info[hook(3, idx)], info[hook(3, idx + 1)]);
    float2 speed = (float2)(info[hook(3, idx + 2)], info[hook(3, idx + 3)]);
    buf[hook(0, idx)] += dir.x * dt * speed.x;
    buf[hook(0, idx + 1)] += dir.y * dt * speed.y;
  }
}