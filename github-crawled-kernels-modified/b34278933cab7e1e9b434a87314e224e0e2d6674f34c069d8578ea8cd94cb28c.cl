//{"cqM":2,"imgSrc":1,"par":0}
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

kernel void CQ(constant struct param* par, global const float* imgSrc, global float* cqM) {
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
    float eps = 0.0001;
    float a = (-0.2) * (it - 1);
    float qt = q0 * exp(a);

    float GradientX = ((imgSrc[hook(1, (r) * iWidth + (c + 1))]) - (imgSrc[hook(1, (r) * iWidth + (c - 1))])) / 2;
    float GradientY = ((imgSrc[hook(1, (r + 1) * iWidth + (c))]) - (imgSrc[hook(1, (r - 1) * iWidth + (c))])) / 2;
    float di1 = sqrt(GradientX * GradientX + GradientY * GradientY);
    float di2 = ((imgSrc[hook(1, (r) * iWidth + (c + 1))]) + (imgSrc[hook(1, (r) * iWidth + (c - 1))]) + (imgSrc[hook(1, (r + 1) * iWidth + (c))]) + (imgSrc[hook(1, (r - 1) * iWidth + (c))])) / 4 - (imgSrc[hook(1, (r) * iWidth + (c))]);

    float t1 = 0.5 * ((di1 / ((imgSrc[hook(1, (r) * iWidth + (c))]) + eps)) * (di1 / ((imgSrc[hook(1, (r) * iWidth + (c))]) + eps)));
    float t2 = 0.625 * ((di2 / ((imgSrc[hook(1, (r) * iWidth + (c))]) + eps)) * (di2 / ((imgSrc[hook(1, (r) * iWidth + (c))]) + eps)));
    float t3 = ((1 + (0.25 * di2 / ((imgSrc[hook(1, (r) * iWidth + (c))]) + eps))) * (1 + (0.25 * di2 / ((imgSrc[hook(1, (r) * iWidth + (c))]) + eps))));
    float t = sqrt(fabs(t1 - t2) / fabs(t3 + eps));
    float dd = (t * t - qt * qt) / (qt * qt * (1 + qt * qt) + eps);

    (cqM[hook(2, (r) * iWidth + (c))]) = 1 / (1 + dd);
  }
}