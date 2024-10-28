//{"fac2":1,"fac3":4,"options2":2,"options3":5,"s1":0,"s2":3,"s3":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void asbs_s_gpu_gpu(global float* s1, global float* fac2, unsigned int options2, global const float* s2, global float* fac3, unsigned int options3, global const float* s3) {
  float alpha = fac2[hook(1, 0)];

  float beta = fac3[hook(4, 0)];
  if (options2 & (1 << 0)) {
    if (options3 & (1 << 0)) {
      if (options2 & (1 << 1)) {
        if (options3 & (1 << 1))
          *s1 += -*s2 / alpha - *s3 / beta;
        else
          *s1 += -*s2 / alpha - *s3 * beta;
      } else {
        if (options3 & (1 << 1))
          *s1 += -*s2 * alpha - *s3 / beta;
        else
          *s1 += -*s2 * alpha - *s3 * beta;
      }
    } else {
      if (options2 & (1 << 1)) {
        if (options3 & (1 << 1))
          *s1 += -*s2 / alpha + *s3 / beta;
        else
          *s1 += -*s2 / alpha + *s3 * beta;
      } else {
        if (options3 & (1 << 1))
          *s1 += -*s2 * alpha + *s3 / beta;
        else
          *s1 += -*s2 * alpha + *s3 * beta;
      }
    }
  } else {
    if (options3 & (1 << 0)) {
      if (options2 & (1 << 1)) {
        if (options3 & (1 << 1))
          *s1 += +*s2 / alpha - *s3 / beta;
        else
          *s1 += +*s2 / alpha - *s3 * beta;
      } else {
        if (options3 & (1 << 1))
          *s1 += +*s2 * alpha - *s3 / beta;
        else
          *s1 += +*s2 * alpha - *s3 * beta;
      }
    } else {
      if (options2 & (1 << 1)) {
        if (options3 & (1 << 1))
          *s1 += +*s2 / alpha + *s3 / beta;
        else
          *s1 += +*s2 / alpha + *s3 * beta;
      } else {
        if (options3 & (1 << 1))
          *s1 += +*s2 * alpha + *s3 / beta;
        else
          *s1 += +*s2 * alpha + *s3 * beta;
      }
    }
  }
}