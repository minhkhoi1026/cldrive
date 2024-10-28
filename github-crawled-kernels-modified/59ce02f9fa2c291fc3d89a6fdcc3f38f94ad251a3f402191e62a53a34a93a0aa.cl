//{"H":14,"H[0]":13,"H[1]":15,"H[2]":16,"H_inv":18,"H_inv[0]":17,"H_inv[1]":19,"H_inv[2]":20,"ImageHeight":7,"ImageWidth":6,"Offset":4,"OffsetNext":5,"OffsetPrev":3,"dD":21,"dI":12,"dataIn":11,"desc":26,"hist":22,"hist[rb]":25,"hist[rb][cb]":24,"intvl":9,"keys":1,"number":2,"octv":10,"orients":23,"prelim_contr_thr":8,"ucSource":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GetPixel(global float* dataIn, int x, int y, int ImageWidth, int ImageHeight) {
  int X = x > ImageWidth ? ImageWidth : x;
  int Y = y > ImageHeight ? ImageHeight : y;
  int GMEMOffset = mul24(Y, ImageWidth) + X;

  return dataIn[hook(11, GMEMOffset)];
}
int is_extremum(global float* dataIn1, global float* dataIn2, global float* dataIn3, int pozX, int pozY, int ImageWidth, int ImageHeight) {
  float val = GetPixel(dataIn2, pozX, pozY, ImageWidth, ImageHeight);

  if (val > 0.0) {
    if (val < GetPixel(dataIn1, pozX - 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX - 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX - 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn1, pozX - 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX - 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX - 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn1, pozX - 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX - 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX - 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;

    if (val < GetPixel(dataIn1, pozX, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn1, pozX, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn1, pozX, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX, pozY + 1, ImageWidth, ImageHeight))
      return 0;

    if (val < GetPixel(dataIn1, pozX + 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX + 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX + 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn1, pozX + 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX + 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX + 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn1, pozX + 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn2, pozX + 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val < GetPixel(dataIn3, pozX + 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
  } else {
    if (val > GetPixel(dataIn1, pozX - 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX - 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX - 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn1, pozX - 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX - 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX - 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn1, pozX - 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX - 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX - 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;

    if (val > GetPixel(dataIn1, pozX, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn1, pozX, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn1, pozX, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX, pozY + 1, ImageWidth, ImageHeight))
      return 0;

    if (val > GetPixel(dataIn1, pozX + 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX + 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX + 1, pozY - 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn1, pozX + 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX + 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX + 1, pozY, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn1, pozX + 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn2, pozX + 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
    if (val > GetPixel(dataIn3, pozX + 1, pozY + 1, ImageWidth, ImageHeight))
      return 0;
  }

  return 1;
}

void deriv_3D(global float* dataIn1, global float* dataIn2, global float* dataIn3, int pozX, int pozY, int ImageWidth, int ImageHeight, float* dI) {
  float dx, dy, ds;
  dx = (GetPixel(dataIn2, pozX + 1, pozY, ImageWidth, ImageHeight) - GetPixel(dataIn2, pozX - 1, pozY, ImageWidth, ImageHeight)) / 2.0;
  dy = (GetPixel(dataIn2, pozX, pozY + 1, ImageWidth, ImageHeight) - GetPixel(dataIn2, pozX, pozY - 1, ImageWidth, ImageHeight)) / 2.0;
  ds = (GetPixel(dataIn3, pozX, pozY, ImageWidth, ImageHeight) - GetPixel(dataIn1, pozX, pozY, ImageWidth, ImageHeight)) / 2.0;
  dI[hook(12, 0)] = dx;
  dI[hook(12, 1)] = dy;
  dI[hook(12, 2)] = ds;
}

void hessian_3D(global float* dataIn1, global float* dataIn2, global float* dataIn3, int pozX, int pozY, int ImageWidth, int ImageHeight, float H[][3]) {
  float v, dxx, dyy, dss, dxy, dxs, dys;

  v = GetPixel(dataIn2, pozX, pozY, ImageWidth, ImageHeight);

  dxx = (GetPixel(dataIn2, pozX + 1, pozY, ImageWidth, ImageHeight) + GetPixel(dataIn2, pozX - 1, pozY, ImageWidth, ImageHeight) - 2 * v);

  dyy = (GetPixel(dataIn2, pozX, pozY + 1, ImageWidth, ImageHeight) + GetPixel(dataIn2, pozX, pozY - 1, ImageWidth, ImageHeight) - 2 * v);

  dss = (GetPixel(dataIn3, pozX, pozY, ImageWidth, ImageHeight) + GetPixel(dataIn1, pozX, pozY, ImageWidth, ImageHeight) - 2 * v);

  dxy = (GetPixel(dataIn2, pozX + 1, pozY + 1, ImageWidth, ImageHeight) - GetPixel(dataIn2, pozX - 1, pozY + 1, ImageWidth, ImageHeight) - GetPixel(dataIn2, pozX + 1, pozY - 1, ImageWidth, ImageHeight) + GetPixel(dataIn2, pozX - 1, pozY - 1, ImageWidth, ImageHeight)) / 4.0;

  dxs = (GetPixel(dataIn3, pozX + 1, pozY, ImageWidth, ImageHeight) - GetPixel(dataIn3, pozX - 1, pozY, ImageWidth, ImageHeight) - GetPixel(dataIn1, pozX + 1, pozY, ImageWidth, ImageHeight) + GetPixel(dataIn1, pozX - 1, pozY, ImageWidth, ImageHeight)) / 4.0;

  dys = (GetPixel(dataIn3, pozX, pozY + 1, ImageWidth, ImageHeight) - GetPixel(dataIn3, pozX, pozY - 1, ImageWidth, ImageHeight) - GetPixel(dataIn1, pozX, pozY + 1, ImageWidth, ImageHeight) + GetPixel(dataIn1, pozX, pozY - 1, ImageWidth, ImageHeight)) / 4.0;

  H[hook(14, 0)][hook(13, 0)] = dxx;
  H[hook(14, 0)][hook(13, 1)] = dxy;
  H[hook(14, 0)][hook(13, 2)] = dxs;
  H[hook(14, 1)][hook(15, 0)] = dxy;
  H[hook(14, 1)][hook(15, 1)] = dyy;
  H[hook(14, 1)][hook(15, 2)] = dys;
  H[hook(14, 2)][hook(16, 0)] = dxs;
  H[hook(14, 2)][hook(16, 1)] = dys;
  H[hook(14, 2)][hook(16, 2)] = dss;
}
void interp_step(global float* dataIn1, global float* dataIn2, global float* dataIn3, int pozX, int pozY, int ImageWidth, int ImageHeight, float* xi, float* xr, float* xc) {
  float dD[3] = {0, 0, 0};
  float H[3][3];
  float H_inv[3][3];

  deriv_3D(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, dD);
  hessian_3D(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, H);

  float a = H[hook(14, 0)][hook(13, 0)];
  float b = H[hook(14, 0)][hook(13, 1)];
  float c = H[hook(14, 0)][hook(13, 2)];
  float d = H[hook(14, 1)][hook(15, 0)];
  float e = H[hook(14, 1)][hook(15, 1)];
  float f = H[hook(14, 1)][hook(15, 2)];
  float g = H[hook(14, 2)][hook(16, 0)];
  float h = H[hook(14, 2)][hook(16, 1)];
  float k = H[hook(14, 2)][hook(16, 2)];

  float det = a * (e * k - f * h) + b * (f * g - k * d) + c * (d * h - e * g);
  float det_inv = 1.0 / det;

  H_inv[hook(18, 0)][hook(17, 0)] = (e * k - f * h) * det_inv;
  H_inv[hook(18, 0)][hook(17, 1)] = (c * h - b * k) * det_inv;
  H_inv[hook(18, 0)][hook(17, 2)] = (b * f - c * e) * det_inv;

  H_inv[hook(18, 1)][hook(19, 0)] = (f * g - d * k) * det_inv;
  H_inv[hook(18, 1)][hook(19, 1)] = (a * k - c * g) * det_inv;
  H_inv[hook(18, 1)][hook(19, 2)] = (c * d - a * f) * det_inv;

  H_inv[hook(18, 2)][hook(20, 0)] = (d * h - e * g) * det_inv;
  H_inv[hook(18, 2)][hook(20, 1)] = (g * b - a * h) * det_inv;
  H_inv[hook(18, 2)][hook(20, 2)] = (a * e - b * d) * det_inv;

  *xc = (-1) * (H_inv[hook(18, 0)][hook(17, 0)] * dD[hook(21, 0)] + H_inv[hook(18, 1)][hook(19, 0)] * dD[hook(21, 1)] + H_inv[hook(18, 2)][hook(20, 0)] * dD[hook(21, 2)]);
  *xr = (-1) * (H_inv[hook(18, 0)][hook(17, 1)] * dD[hook(21, 0)] + H_inv[hook(18, 1)][hook(19, 1)] * dD[hook(21, 1)] + H_inv[hook(18, 2)][hook(20, 1)] * dD[hook(21, 2)]);
  *xi = (-1) * (H_inv[hook(18, 0)][hook(17, 2)] * dD[hook(21, 0)] + H_inv[hook(18, 1)][hook(19, 2)] * dD[hook(21, 1)] + H_inv[hook(18, 2)][hook(20, 2)] * dD[hook(21, 2)]);
}
float interp_contr(global float* dataIn1, global float* dataIn2, global float* dataIn3, int pozX, int pozY, int ImageWidth, int ImageHeight, float xi, float xr, float xc) {
  float dD[3] = {0, 0, 0};
  deriv_3D(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, dD);
  float res = xc * dD[hook(21, 0)] + xr * dD[hook(21, 1)] + xi * dD[hook(21, 2)];

  return GetPixel(dataIn2, pozX, pozY, ImageWidth, ImageHeight) + res * 0.5;
}

float interp_extremum(global float* dataIn1, global float* dataIn2, global float* dataIn3, int pozX, int pozY, int ImageWidth, int ImageHeight, int intvls, float contr_thr, int intvl, float* xi, float* xr, float* xc) {
  float contr;

  int i = 0;
  int siftMaxInterpSteps = 5;

  if (pozX == 668)
    i = 0;

  while (i < siftMaxInterpSteps) {
    interp_step(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, xi, xr, xc);

    if ((((*xi) < 0) ? -(*xi) : (*xi)) <= 0.5 && (((*xr) < 0) ? -(*xr) : (*xr)) <= 0.5 && (((*xc) < 0) ? -(*xc) : (*xc)) <= 0.5)
      break;

    pozX += ((*xc - (int)*xc) <= 0.5 ? (int)*xc : (int)*xc + 1);
    pozY += ((*xr - (int)*xr) <= 0.5 ? (int)*xr : (int)*xr + 1);
    intvl += ((*xc - (int)*xc) <= 0.5 ? (int)*xc : (int)*xc + 1);

    if (intvl < 1 || intvl > intvls || pozX < 5 || pozY < 5 || pozX >= ImageWidth - 5 || pozY >= ImageHeight - 5) {
      return 0;
    }
    i++;
  }

  if (i >= siftMaxInterpSteps)
    return 0;

  contr = interp_contr(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, *xi, *xr, *xc);
  if ((float)(((contr) < 0) ? -(contr) : (contr)) < (float)contr_thr / (float)intvls)
    return 0;

  return 1;
}
int is_too_edge_like(global float* dataIn2, int pozX, int pozY, int ImageWidth, int ImageHeight, float curv_thr) {
  float d, dxx, dyy, dxy, tr, det;

  d = GetPixel(dataIn2, pozX, pozY, ImageWidth, ImageHeight);
  dxx = GetPixel(dataIn2, pozX + 1, pozY, ImageWidth, ImageHeight) + GetPixel(dataIn2, pozX - 1, pozY, ImageWidth, ImageHeight) - 2 * d;
  dyy = GetPixel(dataIn2, pozX, pozY + 1, ImageWidth, ImageHeight) + GetPixel(dataIn2, pozX, pozY - 1, ImageWidth, ImageHeight) - 2 * d;
  dxy = (GetPixel(dataIn2, pozX + 1, pozY + 1, ImageWidth, ImageHeight) - GetPixel(dataIn2, pozX - 1, pozY + 1, ImageWidth, ImageHeight) - GetPixel(dataIn2, pozX + 1, pozY - 1, ImageWidth, ImageHeight) + GetPixel(dataIn2, pozX - 1, pozY - 1, ImageWidth, ImageHeight)) / 4.0;
  tr = dxx + dyy;
  det = dxx * dyy - dxy * dxy;

  if (det <= 0)
    return 1;

  if (tr * tr / det < (float)(curv_thr + 1.0) * (curv_thr + 1.0) / curv_thr)
    return 0;
  return 1;
}
int calc_grad_mag_ori(global float* gauss_pyr, int pozX, int pozY, int ImageWidth, int ImageHeight, float* mag, float* ori) {
  float dx, dy;

  if (pozX > 0 && pozX < ImageWidth - 1 && pozY > 0 && pozY < ImageHeight - 1) {
    dx = GetPixel(gauss_pyr, pozX + 1, pozY, ImageWidth, ImageHeight) - GetPixel(gauss_pyr, pozX - 1, pozY, ImageWidth, ImageHeight);
    dy = GetPixel(gauss_pyr, pozX, pozY - 1, ImageWidth, ImageHeight) - GetPixel(gauss_pyr, pozX, pozY + 1, ImageWidth, ImageHeight);
    *mag = sqrt(dx * dx + dy * dy);
    *ori = atan2(dy, dx);
    return 1;
  }

  else
    return 0;
}
void ori_hist(global float* gauss_pyr, int pozX, int pozY, int ImageWidth, int ImageHeight, float* hist, int n, int rad, float sigma) {
  float mag, ori, w, exp_denom, PI2 = 3.1415926535897932384626433832795 * 2.0;
  int bin, i, j;

  exp_denom = 2.0 * sigma * sigma;

  for (i = -rad; i <= rad; i++)
    for (j = -rad; j <= rad; j++)
      if (calc_grad_mag_ori(gauss_pyr, pozX + i, pozY + j, ImageWidth, ImageHeight, &mag, &ori)) {
        w = exp(-(float)(i * i + j * j) / exp_denom);
        bin = ((n * (ori + 3.1415926535897932384626433832795) / PI2 - (int)n * (ori + 3.1415926535897932384626433832795) / PI2) <= 0.5 ? (int)n * (ori + 3.1415926535897932384626433832795) / PI2 : (int)n * (ori + 3.1415926535897932384626433832795) / PI2 + 1);
        bin = (bin < n) ? bin : 0;
        hist[hook(22, bin)] += w * mag;
      }
}
void smooth_ori_hist(float* hist, int n) {
  float prev, tmp, h0 = hist[hook(22, 0)];
  int i;

  prev = hist[hook(22, n - 1)];

  for (i = 0; i < n; i++) {
    tmp = hist[hook(22, i)];
    hist[hook(22, i)] = 0.25 * prev + 0.5 * hist[hook(22, i)] + 0.25 * ((i + 1 == n) ? h0 : hist[hook(22, i + 1)]);
    prev = tmp;
  }
}
float dominant_ori(float* hist, int n, int* maxBin) {
  float omax;
  int maxbin, i;

  omax = hist[hook(22, 0)];
  maxbin = 0;

  for (i = 1; i < n; i++)
    if (hist[hook(22, i)] > omax) {
      omax = hist[hook(22, i)];
      maxbin = i;
    }

  *maxBin = maxbin;

  return omax;
}

void add_good_ori_features(float* hist, int n, float mag_thr, float* orients, int* numberOrient) {
  float bin, PI2 = 3.1415926535897932384626433832795 * 2.0;
  int l, r, i;

  for (i = 0; i < n; i++) {
    l = (i == 0) ? n - 1 : i - 1;
    r = (i + 1) % n;

    if (hist[hook(22, i)] > hist[hook(22, l)] && hist[hook(22, i)] > hist[hook(22, r)] && hist[hook(22, i)] >= mag_thr) {
      bin = i + (0.5 * ((hist[hook(22, l)]) - (hist[hook(22, r)])) / ((hist[hook(22, l)]) - 2.0 * (hist[hook(22, i)]) + (hist[hook(22, r)])));
      bin = (bin < 0) ? n + bin : (bin >= n) ? bin - n : bin;

      orients[hook(23, *numberOrient)] = ((PI2 * bin) / n) - 3.1415926535897932384626433832795;

      ++(*numberOrient);
    }
  }
}

void interp_hist_entryGPU(float hist[4][4][8], float rbin, float cbin, float obin, float mag, int d, int n) {
  float d_r, d_c, d_o, v_r, v_c, v_o;
  float **row, *h;
  int r0, c0, o0, rb, cb, ob, r, c, o;

  r0 = floor(rbin);
  c0 = floor(cbin);
  o0 = floor(obin);
  d_r = rbin - r0;
  d_c = cbin - c0;
  d_o = obin - o0;
  for (r = 0; r <= 1; r++) {
    rb = r0 + r;
    if (rb >= 0 && rb < d) {
      v_r = mag * ((r == 0) ? 1.0 - d_r : d_r);
      for (c = 0; c <= 1; c++) {
        cb = c0 + c;
        if (cb >= 0 && cb < d) {
          v_c = v_r * ((c == 0) ? 1.0 - d_c : d_c);

          for (o = 0; o <= 1; o++) {
            ob = (o0 + o) % n;

            v_o = v_c * ((o == 0) ? 1.0 - d_o : d_o);

            hist[hook(22, rb)][hook(25, cb)][hook(24, ob)] += v_o;
          }
        }
      }
    }
  }
}

void descr_hist(global float* gauss_pyr, int pozX, int pozY, int ImageWidth, int ImageHeight, float ori, float scl, float hist[4][4][8], int d, int n) {
  float cos_t, sin_t, newOri, hist_width, exp_denom, r_rot, c_rot, grad_mag, grad_ori, w, rbin, cbin, obin, PI2 = 2.0 * 3.1415926535897932384626433832795;
  int radius, i, j;

  cos_t = cos(ori);
  sin_t = sin(ori);
  exp_denom = d * d * 0.5;
  hist_width = 3.0 * scl;
  radius = hist_width * sqrt(2.0) * (d + 1.0) * 0.5 + 0.5;

  for (i = -radius; i <= radius; i++)
    for (j = -radius; j <= radius; j++) {
      c_rot = (j * cos_t - i * sin_t) / hist_width;
      r_rot = (j * sin_t + i * cos_t) / hist_width;
      rbin = r_rot + d / 2 - 0.5;
      cbin = c_rot + d / 2 - 0.5;

      if (rbin > -1.0 && rbin < d && cbin > -1.0 && cbin < d && calc_grad_mag_ori(gauss_pyr, pozX + j, pozY + i, ImageWidth, ImageHeight, &grad_mag, &grad_ori)) {
        grad_ori -= ori;
        newOri = (((grad_ori / PI2) < 0) ? -(grad_ori / PI2) : (grad_ori / PI2));
        if (grad_ori < 0.0) {
          newOri = PI2 - newOri * PI2;
        } else {
          newOri = (newOri - (int)newOri) * PI2;
        }

        obin = newOri * n / PI2;
        w = exp(-(c_rot * c_rot + r_rot * r_rot) / exp_denom);

        interp_hist_entryGPU(hist, rbin, cbin, obin, grad_mag * w, d, n);
      }
    }
}

void normalize_descr(float* desc) {
  float cur, len_inv, len_sq = 0.0;
  int i;

  for (i = 0; i < 128; i++) {
    cur = desc[hook(26, i)];
    len_sq += cur * cur;
  }
  len_inv = 1.0 / sqrt(len_sq);

  for (i = 0; i < 128; i++)
    desc[hook(26, i)] *= len_inv;
}

kernel void ckDetect(global float* ucSource, global float* keys, global int* number, int OffsetPrev, int Offset, int OffsetNext, int ImageWidth, int ImageHeight, float prelim_contr_thr, int intvl, int octv) {
  global float* dataIn1 = &ucSource[hook(0, OffsetPrev)];
  global float* dataIn2 = &ucSource[hook(0, Offset)];
  global float* dataIn3 = &ucSource[hook(0, OffsetNext)];

  int pozX = get_global_id(0);
  int pozY = get_global_id(1);
  int GMEMOffset = mul24(pozY, ImageWidth) + pozX;

  float xc;
  float xr;
  float xi;

  int numberExt = 0;

  float pixel = GetPixel(dataIn2, pozX, pozY, ImageWidth, ImageHeight);

  if (pozX < ImageWidth - 5 && pozY < ImageHeight - 5 && pozX > 5 && pozY > 5 && (((pixel) < 0) ? -(pixel) : (pixel)) > prelim_contr_thr && is_extremum(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight) == 1) {
    float feat = interp_extremum(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, 3, 0.01, intvl, &xi, &xr, &xc);
    if (feat && is_too_edge_like(dataIn2, pozX, pozY, ImageWidth, ImageHeight, 20) != 1) {
      float intvl2 = intvl + xi;

      int offset = 139;
      numberExt = atomic_add(number, (int)1);

      keys[hook(1, numberExt * offset)] = (float)((pozX + xc) * pow((float)2.0, (float)octv) / 2.0);
      keys[hook(1, numberExt * offset + 1)] = (float)((pozY + xr) * pow((float)2.0, (float)octv) / 2.0);
      keys[hook(1, numberExt * offset + 2)] = pozX;
      keys[hook(1, numberExt * offset + 3)] = pozY;
      keys[hook(1, numberExt * offset + 4)] = xi;
      keys[hook(1, numberExt * offset + 5)] = intvl;
      keys[hook(1, numberExt * offset + 6)] = octv;
      keys[hook(1, numberExt * offset + 7)] = (1.6 * pow((float)2.0, (octv + intvl2 / (float)3))) / 2.0;
      keys[hook(1, numberExt * offset + 8)] = 1.6 * pow((float)2.0, (float)(intvl2 / 3));
      keys[hook(1, numberExt * offset + 9)] = 0;
      keys[hook(1, numberExt * offset + 10)] = 0;
    }
  }
}