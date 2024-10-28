//{"backProjectionPic":0,"detectorSpacing":3,"numberDetPixel":4,"numberProj":2,"originX":8,"originY":9,"pixelSpacingReconX":6,"pixelSpacingReconY":7,"sinogram":1,"sizeReconPic":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t linearSampler = 0 | 2 | 0x20;
kernel void OpenCL_BP(global float* backProjectionPic, global float* sinogram, int numberProj, float detectorSpacing, int numberDetPixel, int sizeReconPic, float pixelSpacingReconX, float pixelSpacingReconY, float originX, float originY) {
  const unsigned int x = get_global_id(0);
  const unsigned int y = get_global_id(1);
  const unsigned int idx = y * sizeReconPic + x;

  int locSizex = get_local_size(0);
  int locSizey = get_local_size(1);

  if (x > sizeReconPic || y > sizeReconPic)
    return;

  float backProjOriginX = -(sizeReconPic - 1) * pixelSpacingReconX / 2;
  float backProjOriginY = -(sizeReconPic - 1) * pixelSpacingReconY / 2;

  float pval = 0.f;
  for (int theta = 0; theta < numberProj; theta++) {
    float alpha = ((2.f * 3.14159265358979323846264338327950288f / (numberProj)) * theta);
    float indexX = x * pixelSpacingReconX + backProjOriginX;
    float indexY = y * pixelSpacingReconY + backProjOriginY;
    float s = indexX * cos(alpha) + indexY * sin(alpha);
    s = (s - originY) / detectorSpacing;

    float y = s;
    float y2 = floor(s);
    float y1 = y2 + 1.f;

    float value = 0.f;
    if ((y2 >= 0.f) && (y2 <= 359.f) && (y1 >= 0.f) && (y1 <= 359.f)) {
      float valR1 = sinogram[hook(1, theta + ((int)y1) * numberProj)];
      float valR2 = sinogram[hook(1, theta + ((int)y2) * numberProj)];
      value = (y - y2) * valR1 + (y1 - y) * valR2;
    }
    value = 3.14159265358979323846264338327950288f * value / numberProj;

    pval += value;
  }

  backProjectionPic[hook(0, idx)] = pval;
  return;
}