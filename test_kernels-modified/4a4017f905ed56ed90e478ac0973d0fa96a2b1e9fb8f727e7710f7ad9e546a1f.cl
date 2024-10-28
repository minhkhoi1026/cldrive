//{"dt1":0,"eps":1,"pblock":5,"pos_new":3,"pos_old":2,"vel":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nbody_kern(float dt1, float eps, global float4* pos_old, global float4* pos_new, global float4* vel, local float4* pblock) {
  const float4 dt = (float4)(dt1, dt1, dt1, 0.0f);

  int gti = get_global_id(0);
  int ti = get_local_id(0);

  int n = get_global_size(0);
  int nt = get_local_size(0);
  int nb = n / nt;
  float4 p = pos_old[hook(2, gti)];
  float4 v = vel[hook(4, gti)];

  float4 a = (float4)(0.0f, 0.0f, 0.0f, 0.0f);
  for (int jb = 0; jb < nb; jb++) {
    pblock[hook(5, ti)] = pos_old[hook(2, jb * nt + ti)];
    barrier(0x01);

    for (int j = 0; j < nt; j++) {
      float4 p2 = pblock[hook(5, j)];
      float4 d = p2 - p;
      float invr = rsqrt(d.x * d.x + d.y * d.y + d.z * d.z + eps);
      float f = p2.w * invr * invr * invr;
      a += f * d;
    }

    barrier(0x01);
  }
  p += dt * v + 0.5f * dt * dt * a;
  v += dt * a;

  pos_new[hook(3, gti)] = p;
  vel[hook(4, gti)] = v;
}