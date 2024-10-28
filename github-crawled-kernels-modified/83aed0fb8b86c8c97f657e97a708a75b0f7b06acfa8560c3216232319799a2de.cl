//{"bias":5,"epsilon":7,"expAvgFactor":6,"in":0,"in_cstride":2,"in_nstride":1,"out":3,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BatchNormFwdTrainPerActivation(const global float* restrict in, unsigned int in_nstride, unsigned int in_cstride, global float* restrict out, const global float* restrict scale, const global float* restrict bias, double expAvgFactor, double epsilon) {
  float mean_accum, variance_accum = expAvgFactor;
  float elemStd;
  float invVariance, inhat;
  float pvt_scale, pvt_bias;

  unsigned int xgid = get_global_id(0);
  unsigned int ygid = get_global_id(1);
  unsigned int yglb_sz = get_global_size(1);

  unsigned int Cidx = 1 * xgid;
  unsigned int adjIndex, inImgIndex, index;

  float N = (float)1;

  for (unsigned int img_offset = 0; img_offset < in_cstride; img_offset += yglb_sz) {
    inImgIndex = img_offset + ygid;

    if (inImgIndex < in_cstride) {
      mean_accum = 0.;
      adjIndex = Cidx + inImgIndex;

      for (unsigned int n = 0; n < 1; n++) {
        index = in_nstride * n + adjIndex;
        mean_accum += in[hook(0, index)];
      }
      mean_accum /= N;
      elemStd = 0.;
      variance_accum = 0.;

      for (unsigned int n = 0; n < 1; n++) {
        index = in_nstride * n + adjIndex;
        elemStd = in[hook(0, index)] - mean_accum;
        variance_accum = mad(elemStd, elemStd, (float)variance_accum);
      }
      variance_accum /= N;
      invVariance = rsqrt(variance_accum + epsilon);

      pvt_scale = scale[hook(4, adjIndex)];
      pvt_bias = bias[hook(5, adjIndex)];

      for (unsigned int n = 0; n < 1; n++) {
        index = in_nstride * n + adjIndex;
        elemStd = in[hook(0, index)] - mean_accum;
        inhat = elemStd * invVariance;

        out[hook(3, index)] = mad(pvt_scale, inhat, pvt_bias);
      }
    }
  }
}