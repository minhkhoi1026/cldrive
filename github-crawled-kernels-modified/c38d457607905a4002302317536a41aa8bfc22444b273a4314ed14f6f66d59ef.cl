//{"NewtonsGravConstG":2,"dt1":0,"epssqd":1,"npadding":3,"pblock":7,"pos_curstep":5,"pos_nextstep":6,"pos_stepminus1":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nbody_kern_func_main(const float dt1, const float epssqd, const float NewtonsGravConstG, const int npadding, global float4* pos_stepminus1, global float4* pos_curstep, global float4* pos_nextstep, local float4* pblock) {
  const float4 dt = (float4)(dt1, dt1, dt1, 0.0f);
  int gti = get_global_id(0);
  int ti = get_local_id(0);
  int n = get_global_size(0);
  int nt = get_local_size(0);
  int nb = n / nt;

  int nrealparts = n - npadding;

  float4 pminus1 = pos_stepminus1[hook(4, gti)];
  float4 p = pos_curstep[hook(5, gti)];
  float4 a = (float4)(0.0f, 0.0f, 0.0f, 0.0f);

  for (int jb = 0; jb < nb; jb++) {
    pblock[hook(7, ti)] = pos_curstep[hook(5, jb * nt + ti)];
    barrier(0x01);
    if ((jb * nt + ti) < nrealparts) {
      for (int j = 0; j < nt; j++) {
        if ((jb * nt + j) < nrealparts && (jb * nt + j) != gti) {
          float4 p2 = pblock[hook(7, j)];
          float4 d = p2 - p;
          float invr = rsqrt(d.x * d.x + d.y * d.y + d.z * d.z + epssqd);
          float f = NewtonsGravConstG * p2.w * invr * invr * invr;
          a += f * d;
        }
      }
    }
    barrier(0x01);
  }
  p = (2.0f * p - pminus1 + dt * dt * a);

  if (gti < nrealparts) {
    pos_nextstep[hook(6, gti)] = p;
  }
}