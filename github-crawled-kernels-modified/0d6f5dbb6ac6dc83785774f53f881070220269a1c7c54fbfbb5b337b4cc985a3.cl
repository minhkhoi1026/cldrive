//{"bias":5,"epsilon":6,"estimatedMean":2,"estimatedVariance":3,"in":0,"out":1,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) kernel void BatchNormFwdInferPerActivationEst(const global float* in, global float* restrict out, global float* restrict estimatedMean, global float* restrict estimatedVariance, const global float* restrict scale, const global float* restrict bias, double epsilon) {
  float mean, variance;
  float invVariance, elemStd, inhat;
  float pvt_scale, pvt_bias;
  unsigned int adjIndex, inImgIndex, index;

  int xgid = get_global_id(0);
  int ygid = get_global_id(1);
  int yglb_sz = get_global_size(1);

  int Cidx = 1 * xgid;

  for (int img_offset = 0; img_offset < 1; img_offset += yglb_sz) {
    inImgIndex = img_offset + ygid;
    if (inImgIndex < 1) {
      adjIndex = Cidx + inImgIndex;
      mean = estimatedMean[hook(2, adjIndex)];
      variance = estimatedVariance[hook(3, adjIndex)];
      invVariance = rsqrt(fabs(variance + epsilon));
      pvt_scale = scale[hook(4, adjIndex)];
      pvt_bias = bias[hook(5, adjIndex)];
      for (int n = 0; n < 1; n++) {
        index = 1 * n + adjIndex;
        elemStd = in[hook(0, index)] - mean;
        inhat = elemStd * invVariance;
        out[hook(1, index)] = mad(pvt_scale, inhat, pvt_bias);
      }
    }
  }
}