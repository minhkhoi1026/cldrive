//{"bias":5,"epsilon":6,"estimatedMean":2,"estimatedVariance":3,"in":0,"out":1,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) kernel void BatchNormFwdInferSpatialEst(const global float* restrict in, global float* restrict out, const global float* restrict estimatedMean, const global float* restrict estimatedVariance, const global float* restrict scale, const global float* restrict bias, double epsilon) {
  int xgid = get_global_id(0);
  int ygid = get_global_id(1);
  local float lmean;
  local float lvar;
  local float lscale;
  local float lbias;

  unsigned int cidx = xgid * 1;
  unsigned int index;

  float mean, variance, invVariance;
  float inhat;
  float pscale, pbias;

  if (get_local_id(1) == 0) {
    lmean = estimatedMean[hook(2, xgid)];
    lvar = estimatedVariance[hook(3, xgid)];
    lscale = scale[hook(4, xgid)];
    lbias = bias[hook(5, xgid)];
  }
  barrier(0x01);

  if (ygid < 1) {
    mean = lmean;
    variance = lvar;
    pscale = lscale;
    pbias = lbias;
    invVariance = rsqrt(fabs(variance + epsilon));

    for (int n = 0; n < 1; n++) {
      index = n * 1 + cidx + ygid;
      inhat = (in[hook(0, index)] - mean) * invVariance;
      out[hook(1, index)] = mad(pscale, inhat, pbias);
    }
  }
}