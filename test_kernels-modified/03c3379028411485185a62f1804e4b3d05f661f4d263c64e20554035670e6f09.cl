//{"choice":5,"dt":10,"dx":11,"float3":1,"k":7,"ntracers":4,"num":6,"pos":0,"posn1":2,"posn2":3,"ymax":9,"ymin":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float calc_wave(float4 pjm1, float4 p, float4 pjp1, float4 pn1, int choice, float k, float ymin, float ymax, float dt, float dx) {
  float invdx = 1.f / dx;
  float4 newp = (float4)(0.f, 0.f, 0.f, 0.f);

  if (choice == 1) {
    newp = 2.f * p - pn1 + k * k * dt * dt * invdx * invdx * (pjp1 - 2.f * p + pjm1);
  } else if (choice == 2) {
    float k1 = k * invdx / 2.f;
    newp = -pn1 + 2.f * p + dt * dt * invdx * invdx * ((pjp1 - 2.f * p + pjm1) + k1 * ((pjp1 - p) * (pjp1 - p) - (p - pjm1) * (p - pjm1)));
  } else if (choice == 3) {
    float k2 = k * invdx * invdx / 4.f;
    newp = -pn1 + 2.f * p + dt * dt * invdx * invdx * ((pjp1 - 2.f * p + pjm1) + k2 * ((pjp1 - p) * (pjp1 - p) * (pjp1 - p) - (p - pjm1) * (p - pjm1) * (p - pjm1)));
  }

  float yminm = newp.y < ymin ? ymin : newp.y;
  float ymaxm = yminm > ymax ? ymax : yminm;

  return ymaxm;
}

kernel void wave(global float4* pos, global float4* float3, global float4* posn1, global float4* posn2, int ntracers, int choice, int num, float k, float ymin, float ymax, float dt, float dx) {
  unsigned int ind = get_global_id(0);

  int i, imin, imax;
  int imind = 0;
  int imaxd = num - 1;
  {
    int j = 0;

    i = ind + j * num;
    imin = imind + j * num;
    imax = imaxd + j * num;

    int im1 = i - 1;
    int ip1 = i + 1;
    float4 pjm1 = posn1[hook(2, im1)];
    float4 p = posn1[hook(2, i)];
    float4 pjp1 = posn1[hook(2, ip1)];
    float4 pn1 = posn2[hook(3, i)];

    float4 zero = (float4)(0.f, 0.f, 0.f, 0.f);
    pjm1 = im1 < imin ? zero : pjm1;
    pjp1 = ip1 > imax ? zero : pjp1;

    float ymaxm = calc_wave(pjm1, p, pjp1, pn1, choice, k, ymin, ymax, dt, dx);
    pos[hook(0, i)].y = ymaxm;

    pos[hook(0, i)].w = 1.;

    float col = native_sin(ymaxm * 12 * 3.14f);

    float3[hook(1, i)].y = -1.f * col + 1.f;
    float3[hook(1, i)].x = 1.f * col + 1.f;
    float3[hook(1, i)] *= .09f;
  }
}