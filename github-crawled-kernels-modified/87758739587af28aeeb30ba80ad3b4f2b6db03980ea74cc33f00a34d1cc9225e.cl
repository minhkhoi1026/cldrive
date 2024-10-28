//{"cutsq":4,"force":0,"inum":7,"lj1":5,"lj2":6,"neighCount":2,"neighList":3,"position":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_lj_force(global float4* force, global float4* position, const int neighCount, global int* neighList, const float cutsq, const float lj1, const float lj2, const int inum) {
  unsigned int idx = get_global_id(0);

  float4 ipos = position[hook(1, idx)];
  float4 f = {0.0f, 0.0f, 0.0f, 0.0f};

  int j = 0;
  while (j < neighCount) {
    int jidx = neighList[hook(3, j * inum + idx)];

    float4 jpos = position[hook(1, jidx)];

    float delx = ipos.x - jpos.x;
    float dely = ipos.y - jpos.y;
    float delz = ipos.z - jpos.z;
    float r2inv = delx * delx + dely * dely + delz * delz;

    if (r2inv < cutsq) {
      r2inv = 1.0f / r2inv;
      float r6inv = r2inv * r2inv * r2inv;
      float forceC = r2inv * r6inv * (lj1 * r6inv - lj2);

      f.x += delx * forceC;
      f.y += dely * forceC;
      f.z += delz * forceC;
    }
    j++;
  }

  force[hook(0, idx)] = f;
}