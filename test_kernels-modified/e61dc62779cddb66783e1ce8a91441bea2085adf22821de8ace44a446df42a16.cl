//{"damping":5,"dt1":0,"newVel":4,"oldVel":3,"pblock":7,"pos_new":2,"pos_old":1,"softeningSqr":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nbody_kernel(float dt1, global float4* pos_old, global float4* pos_new, global float4* oldVel, global float4* newVel, float damping, float softeningSqr) {
  const float4 dt = (float4)(dt1, dt1, dt1, 0.0f);
  int gti = get_global_id(0);
  int ti = get_local_id(0);
  int n = get_global_size(0);
  int nt = get_local_size(0);
  int nb = n / nt;
  local float4 pblock[1024];
  float4 p = pos_old[hook(1, gti)];
  float4 v = oldVel[hook(3, gti)];
  float4 a = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (int jb = 0; jb < nb; jb++) {
    pblock[hook(7, ti)] = pos_old[hook(1, jb * nt + ti)];
    barrier(0x01);
    for (int j = 0; j < nt; j++) {
      float4 p2 = pblock[hook(7, j)];
      float4 d = p2 - p;
      float invr = half_rsqrt(d.x * d.x + d.y * d.y + d.z * d.z + softeningSqr);
      float f = p2.w * invr * invr * invr;
      a += f * d;
    }
    barrier(0x01);
  }
  p += dt * v + damping * dt * dt * a;
  v += dt * a;

  pos_new[hook(2, gti)] = p;
  newVel[hook(4, gti)] = v;
}