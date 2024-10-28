//{"destGrid":2,"gProjMatrix":3,"gat_ign":14,"imgGrid":1,"imgSizeX":5,"imgSizeY":6,"imgSizeZ":7,"originX":8,"originY":9,"originZ":10,"p":4,"sino":0,"spacingX":11,"spacingY":12,"spacingZ":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t linearSampler = 0 | 0 | 0x20;
kernel void backProjectPixelDrivenCL(image2d_t sino, global float* imgGrid, global float* destGrid, global float* gProjMatrix, int p, int imgSizeX, int imgSizeY, int imgSizeZ, float originX, float originY, float originZ, float spacingX, float spacingY, float spacingZ, int gat_ign) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);

  if (x >= imgSizeX || y >= imgSizeY)
    return;

  const unsigned int ignfac = (1 + 2 * gat_ign);

  float4 pos = {(float)x * spacingX - originX, (float)y * spacingY - originY, 0.0, 1.0};

  float precomputeR = gProjMatrix[hook(3, p * 12 + 3)] + pos.y * gProjMatrix[hook(3, p * 12 + 1)] + pos.x * gProjMatrix[hook(3, p * 12 + 0)];
  float precomputeS = gProjMatrix[hook(3, p * 12 + 7)] + pos.y * gProjMatrix[hook(3, p * 12 + 5)] + pos.x * gProjMatrix[hook(3, p * 12 + 4)];
  float precomputeT = gProjMatrix[hook(3, p * 12 + 11)] + pos.y * gProjMatrix[hook(3, p * 12 + 9)] + pos.x * gProjMatrix[hook(3, p * 12 + 8)];

  for (int z = 0; z < imgSizeZ; ++z) {
    pos.z = ((float)z * spacingZ) - originZ;
    float r = pos.z * gProjMatrix[hook(3, p * 12 + 2)] + precomputeR;
    float s = pos.z * gProjMatrix[hook(3, p * 12 + 6)] + precomputeS;
    float t = pos.z * gProjMatrix[hook(3, p * 12 + 10)] + precomputeT;

    float denom = 1.0f / t;
    float fu = r * denom;
    float fv = s * denom;
    float2 posUV = {fu + 0.5f, fv + 0.5f};

    float cval = read_imagef(sino, linearSampler, posUV).x;
    cval = cval * denom * denom;

    int idx = x * imgSizeZ * imgSizeY * ignfac + y * imgSizeZ * ignfac + z * ignfac;
    int idx_ign = x * imgSizeZ * imgSizeY * ignfac + y * imgSizeZ * ignfac + z * ignfac + 1;
    unsigned int idxworst = idx_ign;

    for (unsigned int i = 1; i < gat_ign; ++i) {
      if (imgGrid[hook(1, idx_ign + i)] < imgGrid[hook(1, idxworst)])
        idxworst = idx_ign + i;
    }

    if (imgGrid[hook(1, idxworst)] < cval)
      imgGrid[hook(1, idxworst)] = cval;

    idxworst = idx_ign + 2 * gat_ign - 1;

    for (unsigned int i = 1; i < gat_ign; ++i) {
      if (imgGrid[hook(1, idx_ign + 2 * gat_ign - i - 1)] > imgGrid[hook(1, idxworst)])
        idxworst = idx_ign + 2 * gat_ign - i - 1;
    }

    if (imgGrid[hook(1, idxworst)] > cval)
      imgGrid[hook(1, idxworst)] = cval;

    imgGrid[hook(1, idx)] += cval;
  }
}