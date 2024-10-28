//{"H":13,"H[0]":12,"H[1]":14,"H[2]":15,"H_inv":17,"H_inv[0]":16,"H_inv[1]":18,"H_inv[2]":19,"ImageHeight":5,"ImageWidth":4,"Offset":1,"dD":20,"dI":11,"dataIn":10,"desc":25,"hist":21,"hist2":28,"hist2[ii]":27,"hist2[ii][iii]":26,"hist[rb]":24,"hist[rb][cb]":23,"intvl":7,"keys":3,"number":9,"numberExtrema":2,"octv":8,"orients":22,"prelim_contr_thr":6,"ucSource":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float GetPixel(global float* dataIn, int x, int y, int ImageWidth, int ImageHeight) {
  int X = x > ImageWidth ? ImageWidth : x;
  int Y = y > ImageHeight ? ImageHeight : y;
  int GMEMOffset = mul24(Y, ImageWidth) + X;

  return dataIn[hook(10, GMEMOffset)];
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
  dI[hook(11, 0)] = dx;
  dI[hook(11, 1)] = dy;
  dI[hook(11, 2)] = ds;
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

  H[hook(13, 0)][hook(12, 0)] = dxx;
  H[hook(13, 0)][hook(12, 1)] = dxy;
  H[hook(13, 0)][hook(12, 2)] = dxs;
  H[hook(13, 1)][hook(14, 0)] = dxy;
  H[hook(13, 1)][hook(14, 1)] = dyy;
  H[hook(13, 1)][hook(14, 2)] = dys;
  H[hook(13, 2)][hook(15, 0)] = dxs;
  H[hook(13, 2)][hook(15, 1)] = dys;
  H[hook(13, 2)][hook(15, 2)] = dss;
}
void interp_step(global float* dataIn1, global float* dataIn2, global float* dataIn3, int pozX, int pozY, int ImageWidth, int ImageHeight, float* xi, float* xr, float* xc) {
  float dD[3] = {0, 0, 0};
  float H[3][3];
  float H_inv[3][3];

  deriv_3D(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, dD);
  hessian_3D(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, H);

  float a = H[hook(13, 0)][hook(12, 0)];
  float b = H[hook(13, 0)][hook(12, 1)];
  float c = H[hook(13, 0)][hook(12, 2)];
  float d = H[hook(13, 1)][hook(14, 0)];
  float e = H[hook(13, 1)][hook(14, 1)];
  float f = H[hook(13, 1)][hook(14, 2)];
  float g = H[hook(13, 2)][hook(15, 0)];
  float h = H[hook(13, 2)][hook(15, 1)];
  float k = H[hook(13, 2)][hook(15, 2)];

  float det = a * (e * k - f * h) + b * (f * g - k * d) + c * (d * h - e * g);
  float det_inv = 1.0 / det;

  H_inv[hook(17, 0)][hook(16, 0)] = (e * k - f * h) * det_inv;
  H_inv[hook(17, 0)][hook(16, 1)] = (c * h - b * k) * det_inv;
  H_inv[hook(17, 0)][hook(16, 2)] = (b * f - c * e) * det_inv;

  H_inv[hook(17, 1)][hook(18, 0)] = (f * g - d * k) * det_inv;
  H_inv[hook(17, 1)][hook(18, 1)] = (a * k - c * g) * det_inv;
  H_inv[hook(17, 1)][hook(18, 2)] = (c * d - a * f) * det_inv;

  H_inv[hook(17, 2)][hook(19, 0)] = (d * h - e * g) * det_inv;
  H_inv[hook(17, 2)][hook(19, 1)] = (g * b - a * h) * det_inv;
  H_inv[hook(17, 2)][hook(19, 2)] = (a * e - b * d) * det_inv;

  *xc = (-1) * (H_inv[hook(17, 0)][hook(16, 0)] * dD[hook(20, 0)] + H_inv[hook(17, 1)][hook(18, 0)] * dD[hook(20, 1)] + H_inv[hook(17, 2)][hook(19, 0)] * dD[hook(20, 2)]);
  *xr = (-1) * (H_inv[hook(17, 0)][hook(16, 1)] * dD[hook(20, 0)] + H_inv[hook(17, 1)][hook(18, 1)] * dD[hook(20, 1)] + H_inv[hook(17, 2)][hook(19, 1)] * dD[hook(20, 2)]);
  *xi = (-1) * (H_inv[hook(17, 0)][hook(16, 2)] * dD[hook(20, 0)] + H_inv[hook(17, 1)][hook(18, 2)] * dD[hook(20, 1)] + H_inv[hook(17, 2)][hook(19, 2)] * dD[hook(20, 2)]);
}
float interp_contr(global float* dataIn1, global float* dataIn2, global float* dataIn3, int pozX, int pozY, int ImageWidth, int ImageHeight, float xi, float xr, float xc) {
  float dD[3] = {0, 0, 0};
  deriv_3D(dataIn1, dataIn2, dataIn3, pozX, pozY, ImageWidth, ImageHeight, dD);
  float res = xc * dD[hook(20, 0)] + xr * dD[hook(20, 1)] + xi * dD[hook(20, 2)];

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
        hist[hook(21, bin)] += w * mag;
      }
}
void smooth_ori_hist(float* hist, int n) {
  float prev, tmp, h0 = hist[hook(21, 0)];
  int i;

  prev = hist[hook(21, n - 1)];

  for (i = 0; i < n; i++) {
    tmp = hist[hook(21, i)];
    hist[hook(21, i)] = 0.25 * prev + 0.5 * hist[hook(21, i)] + 0.25 * ((i + 1 == n) ? h0 : hist[hook(21, i + 1)]);
    prev = tmp;
  }
}
float dominant_ori(float* hist, int n, int* maxBin) {
  float omax;
  int maxbin, i;

  omax = hist[hook(21, 0)];
  maxbin = 0;

  for (i = 1; i < n; i++)
    if (hist[hook(21, i)] > omax) {
      omax = hist[hook(21, i)];
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

    if (hist[hook(21, i)] > hist[hook(21, l)] && hist[hook(21, i)] > hist[hook(21, r)] && hist[hook(21, i)] >= mag_thr) {
      bin = i + (0.5 * ((hist[hook(21, l)]) - (hist[hook(21, r)])) / ((hist[hook(21, l)]) - 2.0 * (hist[hook(21, i)]) + (hist[hook(21, r)])));
      bin = (bin < 0) ? n + bin : (bin >= n) ? bin - n : bin;

      orients[hook(22, *numberOrient)] = ((PI2 * bin) / n) - 3.1415926535897932384626433832795;

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

            hist[hook(21, rb)][hook(24, cb)][hook(23, ob)] += v_o;
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
    cur = desc[hook(25, i)];
    len_sq += cur * cur;
  }
  len_inv = 1.0 / sqrt(len_sq);

  for (i = 0; i < 128; i++)
    desc[hook(25, i)] *= len_inv;
}

kernel void ckDesc(global float* ucSource, int Offset, global int* numberExtrema, global float* keys, int ImageWidth, int ImageHeight, float prelim_contr_thr, int intvl, int octv, global int* number) {
  ucSource = &ucSource[hook(0, Offset)];
  int numberExt = atomic_add(numberExtrema, (int)1);
  int offset = 139;

  int pozX = get_global_id(0);
  int pozY = get_global_id(1);
  int GMEMOffset = mul24(pozY, ImageWidth) + pozX;

  if (numberExt < *number) {
    float x = keys[hook(3, numberExt * offset + 2)];
    float y = keys[hook(3, numberExt * offset + 3)];
    float scl_octv = keys[hook(3, numberExt * offset + 8)];
    float ori = keys[hook(3, numberExt * offset + 9)];

    float hist[36];

    for (int j = 0; j < 36; j++)
      hist[hook(21, j)] = 0;

    ori_hist(ucSource, x, y, ImageWidth, ImageHeight, hist, 36, ((4.5 * scl_octv - (int)4.5 * scl_octv) <= 0.5 ? (int)4.5 * scl_octv : (int)4.5 * scl_octv + 1), 1.5 * scl_octv);

    for (int j = 0; j < 1; j++)
      smooth_ori_hist(hist, 36);

    int maxBin = 0;
    float omax = dominant_ori(hist, 36, &maxBin);

    float orients[36];
    for (int j = 0; j < 36; j++)
      orients[hook(22, j)] = 0;

    int numberOrient = 0;
    add_good_ori_features(hist, 36, omax * 0.98, orients, &numberOrient);

    ori = orients[hook(22, 0)];
    keys[hook(3, numberExt * offset + 9)] = ori;

    float hist2[4][4][8];

    for (int ii = 0; ii < 4; ii++)
      for (int iii = 0; iii < 4; iii++)
        for (int iiii = 0; iiii < 8; iiii++)
          hist2[hook(28, ii)][hook(27, iii)][hook(26, iiii)] = 0.0;

    descr_hist(ucSource, x, y, ImageWidth, ImageHeight, ori, scl_octv, hist2, 4, 8);

    int k = 0;
    float desc[128];

    for (int ii = 0; ii < 4; ii++)
      for (int iii = 0; iii < 4; iii++)
        for (int iiii = 0; iiii < 8; iiii++)
          desc[hook(25, k++)] = hist2[hook(28, ii)][hook(27, iii)][hook(26, iiii)];

    normalize_descr(desc);

    for (int i = 0; i < k; i++) {
      if (desc[hook(25, i)] > 0.2)
        desc[hook(25, i)] = 0.2;
    }

    normalize_descr(desc);

    for (int i = 0; i < k; i++) {
      desc[hook(25, i)] = min(255, (int)(512.0 * desc[hook(25, i)]));
    }

    for (int i = 0; i < k; i++)
      keys[hook(3, numberExt * offset + 11 + i)] = desc[hook(25, i)];
  }
}