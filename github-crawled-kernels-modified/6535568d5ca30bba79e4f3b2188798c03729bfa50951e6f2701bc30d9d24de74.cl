//{"d_posIn":4,"d_posOut":3,"height":1,"restDistance":2,"width":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 SatisfyConstraint(float4 pos1, float4 int2, float restDistance) {
  float4 toNeighbor = int2 - pos1;
  return (toNeighbor - normalize(toNeighbor) * restDistance);
}
kernel __attribute__((reqd_work_group_size(16, 16, 1))) kernel void SatisfyConstraints(unsigned int width, unsigned int height, float restDistance, global float4* d_posOut, global float4 const* d_posIn) {
  if (get_global_id(0) >= width || get_global_id(1) >= height)
    return;
  unsigned int particleID = get_global_id(0) + get_global_id(1) * width;
  float4 cacheIn = d_posIn[hook(4, particleID)];
  float4 cacheOut = cacheIn;

  if (particleID > width - 1 || (particleID & (7)) != 0) {
    bool lh, gh, lw, gw, llh, ggh, llw, ggw;
    lh = get_global_id(1) < height - 1;
    gh = get_global_id(1) >= 1;
    lw = get_global_id(0) < width - 1;
    gw = get_global_id(0) >= 1;
    llh = get_global_id(1) < height - 2;
    ggh = get_global_id(1) >= 2;
    llw = get_global_id(0) < width - 2;
    ggw = get_global_id(0) >= 2;

    float4 correction = (float)(0.f, 0.f, 0.f, 0.f);
    if (lh)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID + width)], restDistance);
    if (gh)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID - width)], restDistance);
    if (lw)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID + 1)], restDistance);
    if (gw)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID - 1)], restDistance);
    cacheOut += correction * 0.138f;

    correction = (float)(0.f, 0.f, 0.f, 0.f);
    if (lh && lw)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID + width + 1)], hypot(restDistance, restDistance));
    if (lh && gw)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID + width - 1)], hypot(restDistance, restDistance));
    if (gh && lw)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID - width + 1)], hypot(restDistance, restDistance));
    if (gh && gw)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID - width - 1)], hypot(restDistance, restDistance));
    cacheOut += correction * 0.097f;

    correction = (float)(0.f, 0.f, 0.f, 0.f);
    if (llh)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID + 2 * width)], 2 * restDistance);
    if (ggh)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID - 2 * width)], 2 * restDistance);
    if (llw)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID + 2)], 2 * restDistance);
    if (ggw)
      correction += SatisfyConstraint(cacheIn, d_posIn[hook(4, particleID - 2)], 2 * restDistance);
    cacheOut += correction * 0.069f;
  }
  d_posOut[hook(3, particleID)] = cacheOut;
}