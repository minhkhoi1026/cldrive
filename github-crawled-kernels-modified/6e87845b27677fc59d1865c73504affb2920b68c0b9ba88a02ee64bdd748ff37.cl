//{"cqM":1,"imgDes":3,"imgSrc":2,"par":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct param {
  unsigned int iWidth;
  unsigned int iHeight;
  unsigned int it;
  float mean;
  float q0;
  float3 empt;
};

kernel void SRAD(constant struct param* par, global const float* cqM, global const float* imgSrc, global float* imgDes) {
  int iWidth = par->iWidth;
  int iHeight = par->iHeight;
  int it = par->it;
  float mean = par->mean;
  float q0 = par->q0;

  float pixelNum = (iWidth - 4) * (iHeight - 4);

  int iGIDx = get_global_id(0);
  int iGIDy = get_global_id(1);
  int iGIDz = get_global_id(2);
  int iSIZEx = get_global_size(0);
  int iSIZEy = get_global_size(1);
  int iSIZEz = get_global_size(2);
  int idx = iGIDz * iSIZEx * iSIZEy + iGIDy * iSIZEx + iGIDx;

  int r = (idx / (iWidth - 4)) + 2;
  int c = (idx % (iWidth - 4)) + 2;

  if (idx < pixelNum) {
    float GradientX_ = ((cqM[hook(1, (r) * iWidth + (c + 1))]) * ((imgSrc[hook(2, (r) * iWidth + (c + 2))]) - (imgSrc[hook(2, (r) * iWidth + (c))])) - (cqM[hook(1, (r) * iWidth + (c - 1))]) * ((imgSrc[hook(2, (r) * iWidth + (c))]) - (imgSrc[hook(2, (r) * iWidth + (c - 2))]))) / 4;
    float GradientY_ = ((cqM[hook(1, (r + 1) * iWidth + (c))]) * ((imgSrc[hook(2, (r + 2) * iWidth + (c))]) - (imgSrc[hook(2, (r) * iWidth + (c))])) - (cqM[hook(1, (r - 1) * iWidth + (c))]) * ((imgSrc[hook(2, (r) * iWidth + (c))]) - (imgSrc[hook(2, (r - 2) * iWidth + (c))]))) / 4;

    (imgDes[hook(3, (r) * iWidth + (c))]) = (imgSrc[hook(2, (r) * iWidth + (c))]) + 0.035 * (GradientX_ + GradientY_);
    if (r == 2 && c == 2) {
      (imgDes[hook(3, (2) * iWidth + (2))]) = (cqM[hook(1, (r + 1) * iWidth + (c))]);
      (imgDes[hook(3, (2) * iWidth + (3))]) = (imgSrc[hook(2, (r + 2) * iWidth + (c))]);
      (imgDes[hook(3, (2) * iWidth + (4))]) = (imgSrc[hook(2, (r) * iWidth + (c))]);
    }
  }
}