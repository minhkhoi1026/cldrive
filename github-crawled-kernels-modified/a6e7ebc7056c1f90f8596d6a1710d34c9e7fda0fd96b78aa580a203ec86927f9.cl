//{"N":2,"delta_bias":8,"delta_scale":7,"dx_out":5,"dy_in":1,"epsilon":9,"in_cstride":4,"in_nstride":3,"scale":6,"x_in":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void BatchNormBwdPerActivation(const global float* x_in, const global float* dy_in, unsigned int N, unsigned int in_nstride, unsigned int in_cstride, global float* dx_out, const global float* scale, global float* delta_scale, global float* delta_bias, double epsilon) {
  int xgid = get_global_id(0);
  int ygid = get_global_id(1);
  int yglb_sz = get_global_size(1);
  int Cidx = in_cstride * xgid;

  unsigned int inImgIndex, index, adjIndex;
  float mean, invVar;
  float xhat, dyelem;
  float pvt_scale, pvt_dscale;
  float pvt_dbias;
  float tmp1, tmp2, tmp3;
  float elemStd, variance;
  float dxhat = 0.;
  float dxhathat = 0.;

  for (int img_offset = 0; img_offset < in_cstride; img_offset += yglb_sz) {
    mean = 0.;
    inImgIndex = ygid + img_offset;

    if (inImgIndex < in_cstride) {
      adjIndex = Cidx + inImgIndex;
      for (int n = 0; n < N; n++) {
        index = in_nstride * n + adjIndex;
        mean += x_in[hook(0, index)];
      }
      mean /= (float)N;

      elemStd = 0.;
      variance = 0.;

      for (int n = 0; n < N; n++) {
        index = in_nstride * n + adjIndex;
        elemStd = x_in[hook(0, index)] - mean;
        variance = mad(elemStd, elemStd, variance);
      }
      variance /= (float)N;

      invVar = rsqrt(fabs(variance + epsilon));

      pvt_scale = scale[hook(6, adjIndex)];
      pvt_dscale = 0.;
      pvt_dbias = 0.;
      dxhat = 0.;
      dxhathat = 0.;

      for (int n = 0; n < N; n++) {
        index = in_nstride * n + adjIndex;
        elemStd = x_in[hook(0, index)] - mean;
        xhat = elemStd * invVar;
        dyelem = dy_in[hook(1, index)];
        pvt_dbias += dyelem;
        pvt_dscale = mad(xhat, dyelem, pvt_dscale);
        tmp1 = pvt_scale * dyelem;
        dxhat += tmp1;
        dxhathat = mad(tmp1, xhat, dxhathat);
      }

      for (int n = 0; n < N; n++) {
        index = in_nstride * n + adjIndex;
        elemStd = x_in[hook(0, index)] - mean;
        xhat = elemStd * invVar;
        tmp1 = mad(xhat, dxhathat, dxhat);
        tmp2 = mad((float)N, dxhat, -tmp1);
        tmp3 = invVar / ((float)N);
        dx_out[hook(5, index)] = tmp3 * tmp2;
      }

      delta_bias[hook(8, adjIndex)] = pvt_dbias;
      delta_scale[hook(7, adjIndex)] = pvt_dscale;
    }
  }
}