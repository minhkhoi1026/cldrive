//{"gProjMatrix":2,"imgGrid":1,"imgSizeX":4,"imgSizeY":5,"imgSizeZ":6,"originX":7,"originY":8,"originZ":9,"p":3,"sino":0,"spacingX":10,"spacingY":11,"spacingZ":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t linearSampler = 0 | 0 | 0x20;
kernel void backProjectPixelDrivenCL(image2d_t sino, global float* imgGrid, global float* gProjMatrix, int p, int imgSizeX, int imgSizeY, int imgSizeZ, float originX, float originY, float originZ, float spacingX, float spacingY, float spacingZ) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);

  if (x >= imgSizeX || y >= imgSizeY)
    return;

  float4 pos = {(float)x * spacingX - originX, (float)y * spacingY - originY, 0.0, 1.0};
  float precomputeR = gProjMatrix[hook(2, p * 12 + 3)] + pos.y * gProjMatrix[hook(2, p * 12 + 1)] + pos.x * gProjMatrix[hook(2, p * 12 + 0)];
  float precomputeS = gProjMatrix[hook(2, p * 12 + 7)] + pos.y * gProjMatrix[hook(2, p * 12 + 5)] + pos.x * gProjMatrix[hook(2, p * 12 + 4)];
  float precomputeT = gProjMatrix[hook(2, p * 12 + 11)] + pos.y * gProjMatrix[hook(2, p * 12 + 9)] + pos.x * gProjMatrix[hook(2, p * 12 + 8)];

  for (int z = 0; z < imgSizeZ; ++z) {
    pos.z = ((float)z * spacingZ) - originZ;
    float r = pos.z * gProjMatrix[hook(2, p * 12 + 2)] + precomputeR;
    float s = pos.z * gProjMatrix[hook(2, p * 12 + 6)] + precomputeS;
    float t = pos.z * gProjMatrix[hook(2, p * 12 + 10)] + precomputeT;

    float denom = 1.0f / t;
    float fu = r * denom;
    float fv = s * denom;
    float2 posUV = {fu + 0.5f, fv + 0.5f};
    float proj_val = read_imagef(sino, linearSampler, posUV).x;

    int idx = z * imgSizeX * imgSizeY + y * imgSizeX + x;

    imgGrid[hook(1, idx)] += proj_val * denom * denom;
  }
}