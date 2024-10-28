//{"b1":2,"bb2":3,"d1":0,"d2":1,"result":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Srotmg_naive(global float* d1, global float* d2, global float* b1, float bb2, global float* result) {
  float dd1 = *d1;
  float dd2 = *d2;
  float bb1 = *b1;

  float p1 = dd1 * bb1;
  float p2 = dd2 * bb2;
  float q1 = p1 * bb1;
  float q2 = p2 * bb2;
  float h11;
  float h12;
  float h21;
  float h22;
  float sflag;

  if (q1 > fabs(q2)) {
    h12 = p2 / p1;
    h21 = -bb2 / bb1;
    float u = 1.f - h12 * h21;

    sflag = 0.f;
    if (u > 0.f) {
      dd1 /= u;
      dd2 /= u;
      bb1 *= u;
    }
  } else {
    h11 = p1 / p2;
    h22 = bb1 / bb2;
    float u = 1 + h11 * h22;
    float v = dd1 / u;
    sflag = 1.f;
    dd1 = dd2 / u;
    dd2 = v;
    bb1 = bb2 * u;
  }

  const float gamma = 4096.f;
  const float gamma_sq = gamma * gamma;
  const float gamma_msq = 1.f / gamma_sq;

  if (dd1 != 0 && (fabs(dd1) < gamma_msq || fabs(dd1) > gamma_sq)) {
    if (sflag == 0.f) {
      h11 = 1.f;
      h22 = 1.f;
      sflag = -1.f;
    } else {
      h12 = 1.f;
      h21 = -1.f;
      sflag = -1.f;
    }
    while (fabs(dd1) < gamma_msq || fabs(dd1) > gamma_sq) {
      if (fabs(dd1) < gamma_msq) {
        dd1 *= gamma_sq;
        bb1 /= gamma;
        h11 /= gamma;
        h12 /= gamma;
      } else {
        dd1 /= gamma_sq;
        bb1 *= gamma;
        h11 *= gamma;
        h12 *= gamma;
      }
    }
  }

  if (dd2 != 0 && (fabs(dd2) < gamma_msq || fabs(dd2) > gamma_sq)) {
    if (sflag == 0.f) {
      h11 = 1.f;
      h22 = 1.f;
      sflag = -1.f;
    } else if (sflag == 1.f) {
      h12 = 1.f;
      h21 = -1.f;
      sflag = -1.f;
    }
    while (fabs(dd2) < gamma_msq || fabs(dd2) > gamma_sq) {
      if (fabs(dd2) < gamma_msq) {
        dd2 *= gamma_sq;
        h21 /= gamma;
        h22 /= gamma;
      } else {
        dd2 /= gamma_sq;
        h21 *= gamma;
        h22 *= gamma;
      }
    }
  }

  result[hook(4, 0)] = sflag;
  if (sflag == -1.f) {
    result[hook(4, 1)] = h11;
    result[hook(4, 2)] = h21;
    result[hook(4, 3)] = h12;
    result[hook(4, 4)] = h22;
  } else if (sflag == 0.f) {
    result[hook(4, 2)] = h21;
    result[hook(4, 3)] = h12;
  } else {
    result[hook(4, 1)] = h11;
    result[hook(4, 4)] = h22;
  }

  d1[hook(0, 0)] = dd1;
  d2[hook(1, 0)] = dd2;
  b1[hook(2, 0)] = bb1;
}