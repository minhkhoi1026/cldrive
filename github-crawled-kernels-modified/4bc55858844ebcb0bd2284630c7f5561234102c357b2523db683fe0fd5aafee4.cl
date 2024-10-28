//{"accSpace":1,"accSpaceH":4,"accSpaceW":3,"imgH":6,"imgW":5,"sampler":2,"srcImg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int THETA_STEP_DEG = 1;
constant int THETA_STEP_MAX = 180;
constant float DEG2RAD = 0.01745329252f;
kernel void cl_hough(read_only image2d_t srcImg, global unsigned int* accSpace, sampler_t sampler, int accSpaceW, int accSpaceH, int imgW, int imgH) {
  int accSpaceWHalf = accSpaceW / 2;
  int2 absPos = (int2)(get_global_id(0), get_global_id(1));
  float2 pos = (float2)(absPos.x - (float)imgW / 2.0f, absPos.y - (float)imgH / 2.0f);

  float bin = read_imagef(srcImg, sampler, absPos).x;

  if (bin > 0.0f) {
    for (int thetaStep = 0; thetaStep < THETA_STEP_MAX; thetaStep += THETA_STEP_DEG) {
      float theta = (float)thetaStep * DEG2RAD;

      int r = (int)(pos.x * cos(theta) + pos.y * sin(theta));

      if (abs(r) > 2 && r >= -accSpaceWHalf && r < accSpaceWHalf) {
        size_t accPos = thetaStep * accSpaceW + r + accSpaceWHalf;
        atomic_inc(&accSpace[hook(1, accPos)]);
      }
    }
  }
}