//{"contr_thr":5,"curv_thr":4,"dog_c":1,"dog_n":2,"dog_p":0,"intervals":7,"isvalid":3,"o":6,"v":10,"v[0]":9,"v[0][0]":26,"v[0][1]":22,"v[0][2]":25,"v[0][ry + 1]":8,"v[0][ry]":16,"v[1]":12,"v[1][0]":20,"v[1][1]":15,"v[1][2]":19,"v[1][ry + 1]":11,"v[1][ry]":17,"v[2]":14,"v[2][0]":24,"v[2][1]":21,"v[2][2]":23,"v[2][ry + 1]":13,"v[2][ry]":18}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void isvalid(read_only image2d_t dog_p, read_only image2d_t dog_c, read_only image2d_t dog_n, global uchar* isvalid, float curv_thr, float contr_thr, int o, int intervals) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float v[3][3][3];

  for (int ry = -1; ry <= 1; ry++)
    for (int rx = -1; rx <= 1; rx++) {
      v[hook(10, 0)][hook(9, ry + 1)][hook(8, rx + 1)] = read_imagef(dog_p, sampler, (int2)(x + rx, y + ry)).x;
      v[hook(10, 1)][hook(12, ry + 1)][hook(11, rx + 1)] = read_imagef(dog_c, sampler, (int2)(x + rx, y + ry)).x;
      v[hook(10, 2)][hook(14, ry + 1)][hook(13, rx + 1)] = read_imagef(dog_n, sampler, (int2)(x + rx, y + ry)).x;
    }

  const float vcc = v[hook(10, 1)][hook(12, 1)][hook(15, 1)];

  float dmax = -0x1.fffffep127f;
  float dmin = 0x1.fffffep127f;

  for (int ry = 0; ry <= 2; ry++)
    for (int rx = 0; rx <= 2; rx++) {
      dmax = fmax(dmax, fmax(v[hook(10, 0)][hook(9, ry)][hook(16, rx)], fmax(v[hook(10, 1)][hook(12, ry)][hook(17, rx)], v[hook(10, 2)][hook(14, ry)][hook(18, rx)])));

      dmin = fmin(dmin, fmin(v[hook(10, 0)][hook(9, ry)][hook(16, rx)], fmin(v[hook(10, 1)][hook(12, ry)][hook(17, rx)], v[hook(10, 2)][hook(14, ry)][hook(18, rx)])));
    }

  float prelim_contr_thr = 0.5f * contr_thr / intervals;

  bool is_extremum = ((fabs(vcc) > prelim_contr_thr) && ((vcc <= 0.0f && vcc == dmin) || (vcc > 0.0f && vcc == dmax)));

  const float dxx = v[hook(10, 1)][hook(12, 1)][hook(15, 2)] + v[hook(10, 1)][hook(12, 1)][hook(15, 0)] - 2.0f * vcc;
  const float dyy = v[hook(10, 1)][hook(12, 2)][hook(19, 1)] + v[hook(10, 1)][hook(12, 0)][hook(20, 1)] - 2.0f * vcc;
  const float dss = v[hook(10, 2)][hook(14, 1)][hook(21, 1)] + v[hook(10, 0)][hook(9, 1)][hook(22, 1)] - 2.0f * vcc;
  const float dxy = (v[hook(10, 1)][hook(12, 2)][hook(19, 2)] - v[hook(10, 1)][hook(12, 2)][hook(19, 0)] - v[hook(10, 1)][hook(12, 0)][hook(20, 2)] + v[hook(10, 1)][hook(12, 0)][hook(20, 0)]) / 4.0f;
  const float dxs = (v[hook(10, 2)][hook(14, 1)][hook(21, 2)] - v[hook(10, 2)][hook(14, 1)][hook(21, 0)] - v[hook(10, 0)][hook(9, 1)][hook(22, 2)] + v[hook(10, 0)][hook(9, 1)][hook(22, 0)]) / 4.0f;
  const float dys = (v[hook(10, 2)][hook(14, 2)][hook(23, 1)] - v[hook(10, 2)][hook(14, 0)][hook(24, 1)] - v[hook(10, 0)][hook(9, 2)][hook(25, 1)] + v[hook(10, 0)][hook(9, 0)][hook(26, 1)]) / 4.0f;

  float pc_det = dxx * dyy - 2.0f * dxy;
  float pc_tr = dxx + dyy;

  float invdet = 1.0f / ((dxx * (dyy * dss - dys * dys)) - (dxy * (dxy * dss - dys * dxs)) + (dxs * (dxy * dys - dyy * dxs)));

  const float inv_dxx = invdet * (dyy * dss - dys * dys);
  const float inv_dyy = invdet * (dxx * dss - dxs * dxs);
  const float inv_dss = invdet * (dxx * dyy - dxy * dxy);
  const float inv_dxy = invdet * (dxs * dys - dxy * dss);
  const float inv_dxs = invdet * (dxy * dys - dxs * dyy);
  const float inv_dys = invdet * (dxy * dxs - dxx * dys);

  const float dx = (v[hook(10, 1)][hook(12, 1)][hook(15, 2)] - v[hook(10, 1)][hook(12, 1)][hook(15, 0)]) / 2.0f;
  const float dy = (v[hook(10, 1)][hook(12, 2)][hook(19, 1)] - v[hook(10, 1)][hook(12, 0)][hook(20, 1)]) / 2.0f;
  const float ds = (v[hook(10, 2)][hook(14, 1)][hook(21, 1)] - v[hook(10, 0)][hook(9, 1)][hook(22, 1)]) / 2.0f;

  const float interp_x = inv_dxx * dx + inv_dxy * dy + inv_dxs * ds;
  const float interp_y = inv_dxy * dx + inv_dyy * dy + inv_dys * ds;
  const float interp_s = inv_dxs * dx + inv_dys * dy + inv_dss * ds;

  const float interp_contr = interp_x * dx + interp_y * dy + interp_s * ds;

  bool ok = is_extremum && pc_det > 0.0f;
  (pc_tr * pc_tr / pc_det < (curv_thr + 1.0f) * (curv_thr + 1.0f) / curv_thr) && fabs(interp_contr) > contr_thr / intervals&& dx < 1.0f && dy < 1.0f && ds < 1.0f;

  int off = y * get_global_size(0) * (1 << o) + x * (1 << o);

  if (ok)
    isvalid[hook(3, off)] = 1;
}