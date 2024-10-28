//{"dt":5,"m":3,"ps":0,"q":4,"r":2,"vl":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void oclp_kernel(global float* ps, global float* vl, global float* r, global float* m, global float* q, float dt) {
  size_t i = 3 * get_global_id(0);

  float4 pos = (float4)(ps[hook(0, i)], ps[hook(0, i + 1)], ps[hook(0, i + 2)], 1);
  float4 vel = (float4)(vl[hook(1, i)], vl[hook(1, i + 1)], vl[hook(1, i + 2)], 1);

  float4 new_pos = pos + vel * dt;
  if (fabs(new_pos.x) >= 75)
    vel.x = -vel.x;
  if (fabs(new_pos.y) >= 75)
    vel.y = -vel.y;
  if (fabs(new_pos.z) >= 75)
    vel.z = -vel.z;

  pos = pos + vel * dt;

  ps[hook(0, i)] = pos.x;
  ps[hook(0, i + 1)] = pos.y;
  ps[hook(0, i + 2)] = pos.z;
  vl[hook(1, i)] = vel.x;
  vl[hook(1, i + 1)] = vel.y;
  vl[hook(1, i + 2)] = vel.z;
}