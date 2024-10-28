//{"d_NSlices":22,"d_Nx":3,"d_Ny":4,"d_Nz":5,"d_TotSinos":34,"d_atten":36,"d_attenuation_correction":35,"d_bx":9,"d_bxb":14,"d_bxf":11,"d_by":10,"d_byb":15,"d_byf":12,"d_bz":8,"d_bzb":16,"d_bzf":13,"d_d":7,"d_dz":6,"d_elements":1,"d_indices":0,"d_lor":2,"d_maxxx":17,"d_maxyy":18,"d_minxx":19,"d_minyy":20,"d_row":27,"d_size_x":26,"d_x":23,"d_xxa":30,"d_xxv":28,"d_xyindex":32,"d_y":24,"d_yya":31,"d_yyv":29,"d_zdet":25,"d_zindex":33,"d_zmax":21}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void siddon(global int* d_indices, global double* d_elements, global ushort* d_lor, constant int* d_Nx, constant int* d_Ny, constant int* d_Nz, constant double* d_dz, constant double* d_d, constant double* d_bz, constant double* d_bx, constant double* d_by, constant double* d_bxf, constant double* d_byf, constant double* d_bzf, constant double* d_bxb, constant double* d_byb, constant double* d_bzb, constant double* d_maxxx, constant double* d_maxyy, constant double* d_minxx, constant double* d_minyy, constant double* d_zmax, constant double* d_NSlices, global double* d_x, global double* d_y, global double* d_zdet, constant int* d_size_x, constant int* d_row, constant double* d_xxv, constant double* d_yyv, constant double* d_xxa, constant double* d_yya, global int* d_xyindex, global int* d_zindex, constant int* d_TotSinos, constant int* d_attenuation_correction, global double* d_atten) {
  int idx = get_global_id(0);
  double xs, xd, ys, yd, zs, zd;
  if (d_xyindex[hook(32, idx)] >= *d_size_x) {
    xs = d_x[hook(23, d_xyindex[ihook(32, idx))];
    xd = d_x[hook(23, d_xyindex[ihook(32, idx) - *d_size_x)];
    ys = d_y[hook(24, d_xyindex[ihook(32, idx))];
    yd = d_y[hook(24, d_xyindex[ihook(32, idx) - *d_size_x)];
  } else {
    xs = d_x[hook(23, d_xyindex[ihook(32, idx))];
    xd = d_x[hook(23, d_xyindex[ihook(32, idx) + *d_size_x)];
    ys = d_y[hook(24, d_xyindex[ihook(32, idx))];
    yd = d_y[hook(24, d_xyindex[ihook(32, idx) + *d_size_x)];
  }
  if (d_zindex[hook(33, idx)] >= *d_TotSinos) {
    zs = d_zdet[hook(25, d_zindex[ihook(33, idx))];
    zd = d_zdet[hook(25, d_zindex[ihook(33, idx) - *d_TotSinos)];
  } else {
    zs = d_zdet[hook(25, d_zindex[ihook(33, idx))];
    zd = d_zdet[hook(25, d_zindex[ihook(33, idx) + *d_TotSinos)];
  }
  double y_diff = (yd - ys);
  double x_diff = (xd - xs);
  double z_diff = (zd - zs);
  int N2 = d_row[hook(27, idx)];
  int Np = convert_int(d_lor[hook(2, idx)]);
  if (fabs(z_diff) < 1e-8f) {
    int z_loop = convert_int((zs / *d_zmax) * (*d_NSlices - 1.));
    if (fabs(y_diff) < 1e-8f) {
      if (yd <= *d_maxyy && yd >= *d_minyy) {
        double minvalue = *d_maxyy * 1e5;
        int apu;
        double start = *d_yya;
        for (int ii = 0; ii < *d_Ny; ii++) {
          double temp = fabs(start - yd);
          start = start + *d_yyv;
          if (temp < minvalue) {
            minvalue = temp;
            apu = ii;
          }
        }
        double templ_ijk = *d_d;
        int tempk = apu * *d_Ny + z_loop * *d_Nx * *d_Ny;
        double temp = *d_d * convert_double(*d_Nx);
        temp = 1. / temp;
        if (*d_attenuation_correction == 1) {
          double jelppi = 0.;
          for (int iii = 0; iii < Np; iii++) {
            jelppi += (templ_ijk * (-d_atten[hook(36, tempk + iii)]));
          }
          temp = exp(jelppi) * temp;
        }
        templ_ijk = templ_ijk * temp;
        for (int ii = 0; ii < Np; ii++) {
          d_indices[hook(0, ii + N2)] = tempk + ii;
          d_elements[hook(1, ii + N2)] = templ_ijk;
        }
      }
    } else if (fabs(x_diff) < 1e-8f) {
      if (xd <= *d_maxxx && xd >= *d_minxx) {
        double minvalue = *d_maxxx * 1e5;
        int apu;
        double start = *d_xxa;
        for (int ii = 0; ii < *d_Nx; ii++) {
          double temp = fabs(start - xd);
          start = start + *d_xxv;
          if (temp < minvalue) {
            minvalue = temp;
            apu = ii;
          }
        }
        double templ_ijk = *d_d;
        int tempk = apu + z_loop * *d_Nx * *d_Ny;
        double temp = *d_d * convert_double(*d_Ny);
        temp = 1. / temp;
        if (*d_attenuation_correction == 1) {
          double jelppi = 0.;
          for (int iii = 0; iii < Np; iii++) {
            jelppi += (templ_ijk * (-d_atten[hook(36, tempk + iii)]));
          }
          temp = exp(jelppi) * temp;
        }
        templ_ijk = templ_ijk * temp;
        for (int ii = 0; ii < Np; ii++) {
          d_indices[hook(0, ii + N2)] = tempk + ii;
          d_elements[hook(1, ii + N2)] = templ_ijk;
        }
      }
    } else {
      int imin, imax, jmin, jmax, iu, ju, tempi, tempj, tempk;
      double pxt, pyt, tx0, ty0;
      tx0 = (*d_bxf - xs) / (x_diff);
      ty0 = (*d_byf - ys) / (y_diff);
      double txback = (*d_bxb - xs) / (x_diff);
      double tyback = (*d_byb - ys) / (y_diff);
      double txmin = fmin(tx0, txback);
      double txmax = fmax(tx0, txback);
      double tymin = fmin(ty0, tyback);
      double tymax = fmax(ty0, tyback);
      double tmin = fmax(txmin, tymin);
      double tmax = fmin(txmax, tymax);
      if (xs < xd) {
        if (tmin == txmin)
          imin = 1;
        else {
          pxt = xs + tmin * (x_diff);
          imin = convert_int_rtp((pxt - *d_bx) / *d_d);
        }
        if (tmax == txmax)
          imax = *d_Nx;
        else {
          pxt = xs + tmax * (x_diff);
          imax = convert_int_rtn((pxt - *d_bx) / *d_d);
        }
        tx0 = (*d_bx + convert_double(imin) * *d_d - xs) / (x_diff);
        iu = 1;
      } else {
        if (tmin == txmin)
          imax = *d_Nx - 1;
        else {
          pxt = xs + tmin * (x_diff);
          imax = convert_int_rtn((pxt - *d_bx) / *d_d);
        }
        if (tmax == txmax)
          imin = 0;
        else {
          pxt = xs + tmax * (x_diff);
          imin = convert_int_rtp((pxt - *d_bx) / *d_d);
        }
        tx0 = (*d_bx + convert_double(imax) * *d_d - xs) / (x_diff);
        iu = -1;
      }
      if (ys < yd) {
        if (tmin == tymin)
          jmin = 1;
        else {
          pyt = ys + tmin * (y_diff);
          jmin = convert_int_rtp((pyt - *d_by) / *d_d);
        }
        if (tmax == tymax)
          jmax = *d_Ny;
        else {
          pyt = ys + tmax * (y_diff);
          jmax = convert_int_rtn((pyt - *d_by) / *d_d);
        }
        ty0 = (*d_by + convert_double(jmin) * *d_d - ys) / (y_diff);
        ju = 1;
      } else {
        if (tmin == tymin)
          jmax = *d_Ny - 1;
        else {
          pyt = ys + tmin * (y_diff);
          jmax = convert_int_rtn((pyt - *d_by) / *d_d);
        }
        if (tmax == tymax)
          jmin = 0;
        else {
          pyt = ys + tmax * (y_diff);
          jmin = convert_int_rtp((pyt - *d_by) / *d_d);
        }
        ty0 = (*d_by + convert_double(jmax) * *d_d - ys) / (y_diff);
        ju = -1;
      }
      double pt = ((fmin(tx0, ty0) + tmin) / 2.);
      tempi = convert_int_rtn(((xs + pt * x_diff) - *d_bx) / *d_d);
      tempj = convert_int_rtn(((ys + pt * y_diff) - *d_by) / *d_d);
      double txu = *d_d / fabs(x_diff);
      double tyu = *d_d / fabs(y_diff);
      double L = sqrt(x_diff * x_diff + y_diff * y_diff);
      tempk = z_loop * *d_Ny * *d_Nx;
      double tc = tmin;
      if (ty0 < tx0) {
        if (tc == ty0)
          tc -= 1e-7;
      } else {
        if (tc == tx0)
          tc -= 1e-7;
      }
      double temp = 0.;
      double apu, tx0_apu, tc_apu;
      int nnn = 0;
      int n_x_n = 0, n_y_n = 0;
      int apu_tempi;
      bool n_x = false, n_y = false;
      bool apu_var = false;
      for (int ii = 0; ii < Np; ii++) {
        if (tx0 < ty0) {
          if (iu > 0) {
            apu = (tx0 - tc) * L;
            d_elements[hook(1, N2 + ii)] = (apu);
            d_indices[hook(0, N2 + ii)] = tempj * *d_Nx + tempi + tempk;
            tempi += iu;
            tc = tx0;
            tx0 += txu;
            temp += apu;
          } else {
            if (nnn == 0) {
              apu_var = true;
            }
            tempi += iu;
            tx0 += txu;
            nnn++;
          }
        } else {
          if (apu_var) {
            apu_tempi = tempi;
            tx0_apu = tx0;
            tc_apu = tx0 - txu;
            for (int nl = nnn; nl >= 0; nl--) {
              d_indices[hook(0, N2 + ii - nl)] = tempj * *d_Nx + apu_tempi + tempk;
              if (nl == nnn) {
                apu = (ty0 - tc_apu) * L;
              } else if (nl == 0)
                apu = (tx0_apu - tc) * L;
              else {
                apu = (tx0_apu - tc_apu) * L;
              }
              d_elements[hook(1, N2 + ii - nl)] = (apu);
              temp += apu;
              apu_tempi -= iu;
              tx0_apu -= txu;
              tc_apu -= txu;
            }
            apu_var = false;
            nnn = 0;
            tempj += ju;
            tc = ty0;
            ty0 += tyu;
          } else {
            apu = (ty0 - tc) * L;
            d_elements[hook(1, N2 + ii)] = (apu);
            d_indices[hook(0, N2 + ii)] = tempj * *d_Nx + tempi + tempk;

            tempj += ju;
            tc = ty0;
            ty0 += tyu;
            temp += apu;
          }
        }
        if (ii < (Np - 1) && tempj >= *d_Ny) {
          n_y = true;
          n_y_n++;
        }
        if (ii < (Np - 1) && tempi >= *d_Nx) {
          n_x = true;
          n_x_n++;
        }
        if (ii == Np - 1 && apu_var) {
          apu_tempi = tempi - iu;
          tx0_apu = tx0 - txu;
          tc_apu = tx0_apu - txu;
          for (int nl = nnn - 1; nl >= 0; nl--) {
            d_indices[hook(0, N2 + ii - nl)] = tempj * *d_Nx + apu_tempi + tempk;
            if (nl == 0)
              apu = (tx0_apu - tc) * L;
            else {
              apu = (tx0_apu - tc_apu) * L;
            }
            d_elements[hook(1, N2 + ii - nl)] = (apu);
            temp += apu;
            if (nnn > 1) {
              apu_tempi -= iu;
              tx0_apu -= txu;
              tc_apu -= txu;
            }
          }
          apu_var = false;
          nnn = 0;
        }
      }
      if (n_x) {
        for (int ii = 0; ii <= n_x_n; ii++) {
          d_indices[hook(0, N2 + Np - ii - 1)] -= 1;
          if (ii == n_x_n)
            d_indices[hook(0, N2 + Np - ii - 2)] -= (*d_Nx - 1);
        }
      }
      if (n_y) {
        for (int ii = 0; ii <= n_y_n; ii++) {
          if (ii == 0)
            d_indices[hook(0, N2 + Np - 1)] -= *d_Nx;
          else {
            if (d_indices[hook(0, N2 + Np - 1 - ii)] - 1 > d_indices[hook(0, N2 + Np - ii)])
              d_indices[hook(0, N2 + Np - 1 - ii)] -= (*d_Nx - 1);
            else
              d_indices[hook(0, N2 + Np - 1 - ii)] -= 1;
          }
        }
        if (d_indices[hook(0, N2 + Np - 1 - n_y_n)] == d_indices[hook(0, N2 + Np - 2 - n_y_n)])
          d_indices[hook(0, N2 + Np - 2 - n_y_n)] -= 1;
      }
      temp = 1. / temp;
      if (*d_attenuation_correction == 1) {
        double jelppi = 0.;
        for (int iii = 0; iii < Np; iii++) {
          jelppi += (d_elements[hook(1, N2 + iii)] * -d_atten[hook(36, d_indices[Nhook(0, N2 + iii))]);
        }
        temp = exp(jelppi) * temp;
      }
      for (int ii = 0; ii < Np; ii++)
        d_elements[hook(1, ii + N2)] *= temp;
    }
  } else {
    if (fabs(y_diff) < 1e-8f) {
      if (yd <= *d_maxyy && yd >= *d_minyy) {
        double tx0 = (*d_bxf - xs) / (x_diff);
        double tz0 = (*d_bzf - zs) / (z_diff);
        double txback = (*d_bxb - xs) / (x_diff);
        double tzback = (*d_bzb - zs) / (z_diff);
        double txmin = fmin(tx0, txback);
        double txmax = fmax(tx0, txback);
        double tzmin = fmin(tz0, tzback);
        double tzmax = fmax(tz0, tzback);
        double tmin = fmax(txmin, tzmin);
        double tmax = fmin(txmax, tzmax);
        int imin, imax, kmin, kmax;
        double pxt, pzt;
        int iu, ku;
        if (xs < xd) {
          if (tmin == txmin)
            imin = 1;
          else {
            pxt = xs + tmin * (x_diff);
            imin = convert_int_rtp((pxt - *d_bx) / *d_d);
          }
          if (tmax == txmax)
            imax = *d_Nx;
          else {
            pxt = xs + tmax * (x_diff);
            imax = convert_int_rtn((pxt - *d_bx) / *d_d);
          }
          tx0 = (*d_bx + convert_double(imin) * *d_d - xs) / (x_diff);
          iu = 1;
        } else if (xs > xd) {
          if (tmin == txmin)
            imax = *d_Nx - 1;
          else {
            pxt = xs + tmin * (x_diff);
            imax = convert_int_rtn((pxt - *d_bx) / *d_d);
          }
          if (tmax == txmax)
            imin = 0;
          else {
            pxt = xs + tmax * (x_diff);
            imin = convert_int_rtp((pxt - *d_bx) / *d_d);
          }
          tx0 = (*d_bx + convert_double(imax) * *d_d - xs) / (x_diff);
          iu = -1;
        }
        if (zs < zd) {
          if (tmin == tzmin)
            kmin = 1;
          else {
            pzt = zs + tmin * (z_diff);
            kmin = convert_int_rtp((pzt - *d_bz) / *d_dz);
          }
          if (tmax == tzmax)
            kmax = *d_Nz;
          else {
            pzt = zs + tmax * (z_diff);
            kmax = convert_int_rtn((pzt - *d_bz) / *d_dz);
          }
          tz0 = (*d_bz + convert_double(kmin) * *d_dz - zs) / (z_diff);
          ku = 1;
        } else if (zs > zd) {
          if (tmin == tzmin)
            kmax = *d_Nz - 1;
          else {
            pzt = zs + tmin * (z_diff);
            kmax = convert_int_rtn((pzt - *d_bz) / *d_dz);
          }
          if (tmax == tzmax)
            kmin = 0;
          else {
            pzt = zs + tmax * (z_diff);
            kmin = convert_int_rtp((pzt - *d_bz) / *d_dz);
          }
          tz0 = (*d_bz + convert_double(kmax) * *d_dz - zs) / (z_diff);
          ku = -1;
        }
        double L = sqrt((x_diff * x_diff + z_diff * z_diff));
        int tempi, tempj, tempk;
        double apu2, apu1;
        double pt = ((fmin(tx0, tz0) + tmin) / 2.);
        tempi = convert_int_rtn(((xs + pt * x_diff) - *d_bx) / *d_d);
        tempk = convert_int_rtn(((zs + pt * z_diff) - *d_bz) / *d_dz);
        double txu = *d_d / fabs(x_diff);
        double tzu = *d_dz / fabs(z_diff);
        double start = *d_yya;
        for (int ii = 0; ii < Np; ii++) {
          apu1 = fabs(start - yd);
          start = start + *d_yyv;
          if ((ii > 0 && apu1 < apu2) || ii == 0) {
            tempj = ii;
            apu2 = apu1;
          }
        }
        tempj = tempj * *d_Nx;
        double tc = tmin;
        if (tz0 < tx0) {
          if (tc == tz0)
            tc -= 1e-7;
        } else {
          if (tc == tx0)
            tc -= 1e-7;
        }
        double temp = 0.;
        double apu;
        int nnn = 0;
        int apu_tempi;
        bool n_x = false, n_z = false;
        int n_x_n = 0, n_z_n = 0;
        bool apu_var = false;
        double tx0_apu, tc_apu;
        for (int ii = 0; ii < Np; ii++) {
          if (tx0 < tz0) {
            if (iu > 0) {
              apu = (tx0 - tc) * L;
              d_elements[hook(1, N2 + ii)] = (apu);
              d_indices[hook(0, N2 + ii)] = tempj + tempi + *d_Nx * *d_Ny * tempk;
              tempi += iu;
              tc = tx0;
              tx0 += txu;
              temp += apu;
            } else {
              if (nnn == 0) {
                apu_var = true;
              }
              tempi += iu;
              tx0 += txu;
              nnn++;
            }
          } else {
            if (apu_var) {
              apu_tempi = tempi;
              tx0_apu = tx0;
              tc_apu = tx0 - txu;
              for (int nl = nnn; nl >= 0; nl--) {
                d_indices[hook(0, N2 + ii - nl)] = tempj + apu_tempi + *d_Nx * *d_Ny * tempk;
                if (nl == nnn) {
                  apu = (tz0 - tc_apu) * L;
                } else if (nl == 0)
                  apu = (tx0_apu - tc) * L;
                else {
                  apu = (tx0_apu - tc_apu) * L;
                }
                d_elements[hook(1, N2 + ii - nl)] = (apu);
                temp += apu;
                apu_tempi -= iu;
                tx0_apu -= txu;
                tc_apu -= txu;
              }
              apu_var = false;
              nnn = 0;
              tempk += ku;
              tc = tz0;
              tz0 += tzu;
            } else {
              apu = (tz0 - tc) * L;
              d_elements[hook(1, N2 + ii)] = (apu);
              d_indices[hook(0, N2 + ii)] = tempj + tempi + *d_Nx * *d_Ny * tempk;
              tempk += ku;
              tc = tz0;
              tz0 += tzu;
              temp += apu;
            }
          }
          if (ii < (Np - 1) && tempi >= *d_Nx) {
            n_x = true;
            n_x_n++;
          }
          if (ii < (Np - 1) && tempk >= *d_Nz) {
            n_z = true;
            n_z_n++;
          }
          if (ii == Np - 1 && apu_var) {
            apu_tempi = tempi - iu;
            tx0_apu = tx0 - txu;
            tc_apu = tx0_apu - txu;
            for (int nl = nnn - 1; nl >= 0; nl--) {
              d_indices[hook(0, N2 + ii - nl)] = tempj + apu_tempi + *d_Nx * *d_Ny * tempk;
              if (nl == 0)
                apu = (tx0_apu - tc) * L;
              else {
                apu = (tx0_apu - tc_apu) * L;
              }
              d_elements[hook(1, N2 + ii - nl)] = (apu);
              temp += apu;
              if (nnn > 1) {
                apu_tempi -= iu;
                tx0_apu -= txu;
                tc_apu -= txu;
              }
            }
            apu_var = false;
            nnn = 0;
          }
        }
        if (n_x) {
          for (int ii = 0; ii <= n_x_n; ii++) {
            d_indices[hook(0, N2 + Np - ii - 1)] -= 1;
            if (ii == n_x_n)
              d_indices[hook(0, N2 + Np - ii - 2)] -= (*d_Nx - 1);
          }
        }
        if (n_z) {
          for (int ii = 0; ii <= n_z_n; ii++) {
            if (ii == 0)
              d_indices[hook(0, N2 + Np - 1)] -= (*d_Nx * *d_Ny);
            else {
              if (d_indices[hook(0, N2 + Np - 1 - ii)] - 1 > d_indices[hook(0, N2 + Np - ii)])
                d_indices[hook(0, N2 + Np - 1 - ii)] -= (*d_Nx * *d_Ny - 1);
              else
                d_indices[hook(0, N2 + Np - 1 - ii)] -= 1;
            }
          }
          if (d_indices[hook(0, N2 + Np - 1 - n_z_n)] == d_indices[hook(0, N2 + Np - 2 - n_z_n)])
            d_indices[hook(0, N2 + Np - 2 - n_z_n)] -= 1;
        }
        temp = 1. / temp;
        if (*d_attenuation_correction == 1) {
          double jelppi = 0.;
          for (int iii = 0; iii < Np; iii++) {
            jelppi += (d_elements[hook(1, N2 + iii)] * (-d_atten[hook(36, d_indices[Nhook(0, N2 + iii))]));
          }
          temp = exp(jelppi) * temp;
        }
        for (int ii = 0; ii < Np; ii++) {
          d_elements[hook(1, N2 + ii)] *= temp;
        }
      }
    } else if (fabs(x_diff) < 1e-8f) {
      if (xd <= *d_maxxx && xd >= *d_minxx) {
        double ty0 = (*d_byf - ys) / (y_diff);
        double tyback = (*d_byb - ys) / (y_diff);
        double tz0 = (*d_bzf - zs) / (z_diff);
        double tzback = (*d_bzb - zs) / (z_diff);
        double tzmin = fmin(tz0, tzback);
        double tzmax = fmax(tz0, tzback);
        double tymin = fmin(ty0, tyback);
        double tymax = fmax(ty0, tyback);
        double tmin = fmax(tymin, tzmin);
        double tmax = fmin(tymax, tzmax);
        int jmin, jmax, kmin, kmax, ku, ju;
        double pyt, pzt;
        if (ys < yd) {
          if (tmin == tymin)
            jmin = 1;
          else {
            pyt = ys + tmin * (y_diff);
            jmin = convert_int_rtp((pyt - *d_by) / *d_d);
          }
          if (tmax == tymax)
            jmax = *d_Ny;
          else {
            pyt = ys + tmax * (y_diff);
            jmax = convert_int_rtn((pyt - *d_by) / *d_d);
          }
          ty0 = (*d_by + convert_double(jmin) * *d_d - ys) / (y_diff);
          ju = 1;
        } else if (ys > yd) {
          if (tmin == tymin)
            jmax = *d_Ny - 1;
          else {
            pyt = ys + tmin * (y_diff);
            jmax = convert_int_rtn((pyt - *d_by) / *d_d);
          }
          if (tmax == tymax)
            jmin = 0;
          else {
            pyt = ys + tmax * (y_diff);
            jmin = convert_int_rtp((pyt - *d_by) / *d_d);
          }
          ty0 = (*d_by + convert_double(jmax) * *d_d - ys) / (y_diff);
          ju = -1;
        }
        if (zs < zd) {
          if (tmin == tzmin)
            kmin = 1;
          else {
            pzt = zs + tmin * (z_diff);
            kmin = convert_int_rtp((pzt - *d_bz) / *d_dz);
          }
          if (tmax == tzmax)
            kmax = *d_Nz;
          else {
            pzt = zs + tmax * (z_diff);
            kmax = convert_int_rtn((pzt - *d_bz) / *d_dz);
          }
          tz0 = (*d_bz + convert_double(kmin) * *d_dz - zs) / (z_diff);
          ku = 1;
        } else if (zs > zd) {
          if (tmin == tzmin)
            kmax = *d_Nz - 1;
          else {
            pzt = zs + tmin * (z_diff);
            kmax = convert_int_rtn((pzt - *d_bz) / *d_dz);
          }
          if (tmax == tzmax)
            kmin = 0;
          else {
            pzt = zs + tmax * (z_diff);
            kmin = convert_int_rtp((pzt - *d_bz) / *d_dz);
          }
          tz0 = (*d_bz + convert_double(kmax) * *d_dz - zs) / (z_diff);
          ku = -1;
        }
        double L = sqrt((y_diff * y_diff + z_diff * z_diff));
        int tempi, tempj, tempk;
        double apu2, apu1, apu;
        double pt = ((min(tz0, ty0) + tmin) / 2.);
        tempk = convert_int_rtn(((zs + pt * z_diff) - *d_bz) / *d_dz);
        tempj = convert_int_rtn(((ys + pt * y_diff) - *d_by) / *d_d);
        double tzu = *d_dz / fabs(z_diff);
        double tyu = *d_d / fabs(y_diff);
        double tc = tmin;
        if (tz0 < ty0) {
          if (tc == tz0)
            tc -= 1e-7;
        } else {
          if (tc == ty0)
            tc -= 1e-7;
        }
        double temp = 0.;
        double start = *d_yya;
        for (int ii = 0; ii < *d_Nx; ii++) {
          apu1 = fabs(start - xd);
          start = start + *d_yyv;
          if ((ii > 0 && apu1 < apu2) || ii == 0) {
            tempi = ii;
            apu2 = apu1;
          }
        }
        int nnn = 0;
        int apu_tempj;
        bool n_z = false, n_y = false;
        bool apu_var = false;
        int n_y_n = 0, n_z_n = 0;
        double ty0_apu, tc_apu;
        for (int ii = 0; ii < Np; ii++) {
          if (tz0 < ty0) {
            if (apu_var) {
              apu_tempj = tempj;
              ty0_apu = ty0;
              tc_apu = ty0 - tyu;
              for (int nl = nnn; nl >= 0; nl--) {
                d_indices[hook(0, N2 + ii - nl)] = apu_tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
                if (nl == nnn) {
                  apu = (tz0 - tc_apu) * L;
                } else if (nl == 0)
                  apu = (ty0_apu - tc) * L;
                else {
                  apu = (ty0_apu - tc_apu) * L;
                }
                d_elements[hook(1, N2 + ii - nl)] = (apu);
                temp += apu;
                apu_tempj -= ju;
                ty0_apu -= tyu;
                tc_apu -= tyu;
              }
              apu_var = false;
              nnn = 0;
              tempk += ku;
              tc = tz0;
              tz0 += tzu;
            } else {
              apu = (tz0 - tc) * L;
              d_elements[hook(1, N2 + ii)] = (apu);
              d_indices[hook(0, N2 + ii)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
              tempk += ku;
              tc = tz0;
              tz0 += tzu;
              temp += apu;
            }
          } else {
            if (ju > 0) {
              apu = (ty0 - tc) * L;
              d_elements[hook(1, N2 + ii)] = (apu);
              d_indices[hook(0, N2 + ii)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
              tempj += ju;
              tc = ty0;
              ty0 += tyu;
              temp += apu;
            } else {
              if (nnn == 0) {
                apu_var = true;
              }
              tempj += ju;
              ty0 += tyu;
              nnn++;
            }
          }
          if (ii < (Np - 1) && tempj >= *d_Ny) {
            n_y = true;
            n_y_n++;
          }
          if (ii < (Np - 1) && tempk >= *d_Nz) {
            n_z = true;
            n_z_n++;
          }
          if (ii == Np - 1 && apu_var) {
            apu_tempj = tempj - ju;
            ty0_apu = ty0 - tyu;
            tc_apu = ty0_apu - tyu;
            for (int nl = nnn - 1; nl >= 0; nl--) {
              d_indices[hook(0, N2 + ii - nl)] = apu_tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
              if (nl == 0)
                apu = (ty0_apu - tc) * L;
              else {
                apu = (ty0_apu - tc_apu) * L;
              }
              d_elements[hook(1, N2 + ii - nl)] = (apu);
              temp += apu;
              if (nnn > 1) {
                apu_tempj -= ju;
                ty0_apu -= tyu;
                tc_apu -= tyu;
              }
            }
            apu_var = false;
            nnn = 0;
          }
        }
        if (n_y) {
          for (int ii = 0; ii <= n_y_n; ii++) {
            if (ii == 0)
              d_indices[hook(0, N2 + Np - 1)] -= *d_Nx;
            else {
              if (d_indices[hook(0, N2 + Np - 1 - ii)] - 1 > d_indices[hook(0, N2 + Np - ii)])
                d_indices[hook(0, N2 + Np - 1 - ii)] -= (*d_Nx - 1);
              else
                d_indices[hook(0, N2 + Np - 1 - ii)] -= 1;
            }
          }
          if (d_indices[hook(0, N2 + Np - 1 - n_y_n)] == d_indices[hook(0, N2 + Np - 2 - n_y_n)])
            d_indices[hook(0, N2 + Np - 2 - n_y_n)] -= 1;
        }
        if (n_z) {
          for (int ii = 0; ii <= n_z_n; ii++) {
            if (ii == 0)
              d_indices[hook(0, N2 + Np - 1)] -= (*d_Nx * *d_Ny);
            else {
              if (d_indices[hook(0, N2 + Np - 1 - ii)] - 1 > d_indices[hook(0, N2 + Np - ii)])
                d_indices[hook(0, N2 + Np - 1 - ii)] -= (*d_Nx * *d_Ny - 1);
              else
                d_indices[hook(0, N2 + Np - 1 - ii)] -= 1;
            }
          }
          if (d_indices[hook(0, N2 + Np - 1 - n_z_n)] == d_indices[hook(0, N2 + Np - 2 - n_z_n)])
            d_indices[hook(0, N2 + Np - 2 - n_z_n)] -= 1;
        }
        temp = 1. / temp;
        if (*d_attenuation_correction == 1) {
          double jelppi = 0.;
          for (int iii = 0; iii < Np; iii++) {
            jelppi += (d_elements[hook(1, N2 + iii)] * (-d_atten[hook(36, d_indices[Nhook(0, N2 + iii))]));
          }
          temp = exp(jelppi) * temp;
        }
        for (int ii = 0; ii < Np; ii++) {
          d_elements[hook(1, N2 + ii)] *= temp;
        }
      }
    } else {
      double tx0 = (*d_bxf - xs) / (x_diff);
      double tz0 = (*d_bzf - zs) / (z_diff);
      double txback = (*d_bxb - xs) / (x_diff);
      double tzback = (*d_bzb - zs) / (z_diff);
      double ty0 = (*d_byf - ys) / (y_diff);
      double tyback = (*d_byb - ys) / (y_diff);
      double txmin = fmin(tx0, txback);
      double txmax = fmax(tx0, txback);
      double tymin = fmin(ty0, tyback);
      double tymax = fmax(ty0, tyback);
      double tzmin = fmin(tz0, tzback);
      double tzmax = fmax(tz0, tzback);
      double tmin = fmax(max(txmin, tzmin), tymin);
      double tmax = fmin(min(txmax, tzmax), tymax);
      int imin, imax, jmin, jmax, kmin, kmax, iu, ju, ku;
      double pxt, pyt, pzt;
      if (xs < xd) {
        if (tmin == txmin)
          imin = 1;
        else {
          pxt = xs + tmin * (x_diff);
          imin = convert_int_rtp((pxt - *d_bx) / *d_d);
        }
        if (tmax == txmax)
          imax = *d_Nx;
        else {
          pxt = xs + tmax * (x_diff);
          imax = convert_int_rtn((pxt - *d_bx) / *d_d);
        }
        tx0 = (*d_bx + convert_double(imin) * *d_d - xs) / (x_diff);
        iu = 1;
      } else if (xs > xd) {
        if (tmin == txmin)
          imax = *d_Nx - 1;
        else {
          pxt = xs + tmin * (x_diff);
          imax = convert_int_rtn((pxt - *d_bx) / *d_d);
        }
        if (tmax == txmax)
          imin = 0;
        else {
          pxt = xs + tmax * (x_diff);
          imin = convert_int_rtp((pxt - *d_bx) / *d_d);
        }
        tx0 = (*d_bx + convert_double(imax) * *d_d - xs) / (x_diff);
        iu = -1;
      }
      if (ys < yd) {
        if (tmin == tymin)
          jmin = 1;
        else {
          pyt = ys + tmin * (y_diff);
          jmin = convert_int_rtp((pyt - *d_by) / *d_d);
        }
        if (tmax == tymax)
          jmax = *d_Ny;
        else {
          pyt = ys + tmax * (y_diff);
          jmax = convert_int_rtn((pyt - *d_by) / *d_d);
        }
        ty0 = (*d_by + convert_double(jmin) * *d_d - ys) / (y_diff);
        ju = 1;
      } else if (ys > yd) {
        if (tmin == tymin)
          jmax = *d_Ny - 1;
        else {
          pyt = ys + tmin * (y_diff);
          jmax = convert_int_rtn((pyt - *d_by) / *d_d);
        }
        if (tmax == tymax)
          jmin = 0;
        else {
          pyt = ys + tmax * (y_diff);
          jmin = convert_int_rtp((pyt - *d_by) / *d_d);
        }
        ty0 = (*d_by + convert_double(jmax) * *d_d - ys) / (y_diff);
        ju = -1;
      }
      if (zs < zd) {
        if (tmin == tzmin)
          kmin = 1;
        else {
          pzt = zs + tmin * (z_diff);
          kmin = convert_int_rtp((pzt - *d_bz) / *d_dz);
        }
        if (tmax == tzmax)
          kmax = *d_Nz;
        else {
          pzt = zs + tmax * (z_diff);
          kmax = convert_int_rtn((pzt - *d_bz) / *d_dz);
        }
        tz0 = (*d_bz + convert_double(kmin) * *d_dz - zs) / (z_diff);
        ku = 1;
      } else if (zs > zd) {
        if (tmin == tzmin)
          kmax = *d_Nz - 1;
        else {
          pzt = zs + tmin * (z_diff);
          kmax = convert_int_rtn((pzt - *d_bz) / *d_dz);
        }
        if (tmax == tzmax)
          kmin = 0;
        else {
          pzt = zs + tmax * (z_diff);
          kmin = convert_int_rtp((pzt - *d_bz) / *d_dz);
        }
        tz0 = (*d_bz + convert_double(kmax) * *d_dz - zs) / (z_diff);
        ku = -1;
      }
      double L = sqrt(x_diff * x_diff + z_diff * z_diff + y_diff * y_diff);
      int tempi, tempj, tempk;
      double pt = ((fmin(fmin(tz0, ty0), tx0) + tmin) / 2.);
      tempk = convert_int_rtn(((zs + pt * z_diff) - *d_bz) / *d_dz);
      tempj = convert_int_rtn(((ys + pt * y_diff) - *d_by) / *d_d);
      tempi = convert_int_rtn(((xs + pt * x_diff) - *d_bx) / *d_d);
      double tzu = *d_dz / fabs(z_diff);
      double tyu = *d_d / fabs(y_diff);
      double txu = *d_d / fabs(x_diff);
      double tc = tmin;
      if (tz0 < ty0 && tz0 < tx0) {
        if (tc == tz0)
          tc -= 1e-7;
      } else if (ty0 < tx0) {
        if (tc == ty0)
          tc -= 1e-7;
      } else {
        if (tc == tx0)
          tc -= 1e-7;
      }
      double temp = 0.;
      double apu;
      int nnn = 0;
      int apu_tempi, apu_tempj;
      bool apu_varx = false, apu_vary = false, apu_varx2 = false;
      double tx0_apu, tc_apu, ty0_apu;
      bool final_x = false, final_y = false, first_x = false, first_y = false;
      bool n_x = false, n_y = false, n_z = false;
      int nnx = 0;
      int nny = 0;
      int nyy = 0;
      int nxx = 0;
      int n_x_n = 0, n_y_n = 0, n_z_n = 0;
      for (int ii = 0; ii < Np; ii++) {
        if (tz0 < ty0 && tz0 < tx0) {
          if (apu_varx && apu_vary == false) {
            apu_tempi = tempi;
            tx0_apu = tx0;
            tc_apu = tx0 - txu;
            for (int nl = nnn; nl >= 0; nl--) {
              d_indices[hook(0, N2 + ii - nl)] = tempj * *d_Nx + apu_tempi + *d_Nx * *d_Ny * tempk;
              if (nl == nnn)
                apu = (tz0 - tc_apu) * L;
              else if (nl == 0)
                apu = (tx0_apu - tc) * L;
              else {
                apu = (tx0_apu - tc_apu) * L;
              }
              d_elements[hook(1, N2 + ii - nl)] = (apu);
              temp += apu;
              apu_tempi -= iu;
              tx0_apu -= txu;
              tc_apu -= txu;
            }
            apu_varx = false;
            nnn = 0;
          } else if (apu_vary && apu_varx == false) {
            if (apu_varx2) {
              if (final_x) {
                apu_tempi = tempi;
                tx0_apu = tx0;
                apu_tempj = tempj;
                ty0_apu = ty0;
              } else {
                apu_tempj = tempj - ju;
                ty0_apu = ty0 - tyu;
                apu_tempi = tempi;
                tx0_apu = tx0;
                tc_apu = ty0_apu;
                apu = (tz0 - tc_apu) * L;
                d_elements[hook(1, N2 + ii - nnn - nnx)] = (apu);
                d_indices[hook(0, N2 + ii - nnn - nnx)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
                temp += apu;
                nnn--;
              }
              double tx0_apu2 = tx0_apu;
              double tc_apu2 = tc;
              int apu_tempi2 = tempi;
              for (int nl = nnn; nl >= 0; nl--) {
                int nnnx = 0;
                while (tx0_apu2 - txu >= ty0_apu - tyu && nnnx < nnx) {
                  nnnx++;
                  tx0_apu2 -= txu;
                  apu_tempi2 -= iu;
                }
                if (nl == 0 && first_x)
                  tc_apu2 = tc;
                else if (nnnx > 0)
                  tc_apu2 = ty0_apu - tyu;
                double tx0_apu3 = tx0_apu2;
                int apu_tempi3 = apu_tempi2;
                if (nnnx > 0) {
                  for (int nlx = 0; nlx < (nnnx); nlx++) {
                    d_indices[hook(0, N2 + ii - nl - (nnx - nlx))] = apu_tempj * *d_Nx + apu_tempi2 + *d_Nx * *d_Ny * tempk;
                    apu = (tx0_apu2 - tc_apu2) * L;
                    d_elements[hook(1, N2 + ii - nl - (nnx - nlx))] = (apu);
                    temp += apu;
                    tc_apu2 = tx0_apu2;
                    if (nlx < (nnnx)-1) {
                      apu_tempi2 += iu;
                      tx0_apu2 += txu;
                    }
                  }
                  nnx -= nnnx;
                  tx0_apu2 = tx0_apu3;
                  apu_tempi2 = apu_tempi3;
                  apu_tempi3 += nnnx * iu;
                }
                if (nnnx > 0)
                  d_indices[hook(0, N2 + ii - nl - nnx)] = apu_tempj * *d_Nx + apu_tempi3 + *d_Nx * *d_Ny * tempk;
                else
                  d_indices[hook(0, N2 + ii - nl - nnx)] = apu_tempj * *d_Nx + apu_tempi2 + *d_Nx * *d_Ny * tempk;
                if (nl == nnn) {
                  if (nnnx)
                    tc_apu2 = tx0_apu - txu;
                  else
                    tc_apu2 = ty0_apu - tyu;
                } else if ((nl > 0 && nnnx > 0) || (nl == 0 && nnnx > 0)) {
                } else if (nl > 0) {
                  tc_apu2 = ty0_apu - tyu;
                } else if (first_y) {
                  tc_apu2 = tc;
                }
                if (nl == nnn && final_x)
                  apu = (tz0 - tc_apu2) * L;
                else
                  apu = (ty0_apu - tc_apu2) * L;
                d_elements[hook(1, N2 + ii - nl - nnx)] = (apu);
                temp += apu;
                apu_tempj -= ju;
                ty0_apu -= tyu;
              }
              apu_vary = false;
              nnn = 0;
              apu_varx2 = false;
              nnx = 0;
              first_y = false;
              first_x = false;
            } else {
              apu_tempj = tempj;
              ty0_apu = ty0;
              tc_apu = ty0 - tyu;
              for (int nl = nnn; nl >= 0; nl--) {
                d_indices[hook(0, N2 + ii - nl)] = apu_tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
                if (nl == nnn) {
                  apu = (tz0 - tc_apu) * L;
                } else if (nl == 0)
                  apu = (ty0_apu - tc) * L;
                else {
                  apu = (ty0_apu - tc_apu) * L;
                }
                d_elements[hook(1, N2 + ii - nl)] = (apu);
                temp += apu;
                apu_tempj -= ju;
                ty0_apu -= tyu;
                tc_apu -= tyu;
              }
              apu_vary = false;
              nnn = 0;
              first_y = false;
            }
          } else if (apu_varx && apu_vary) {
            bool apu_bool = false;
            if (final_x) {
              apu_tempi = tempi;
              tx0_apu = tx0;
              apu_tempj = tempj;
              ty0_apu = ty0;
              tc_apu = tx0_apu - txu;
              apu_bool = true;
            } else {
              apu_tempj = tempj;
              ty0_apu = ty0;
              apu_tempi = tempi;
              tx0_apu = tx0;
              tc_apu = ty0_apu - tyu;
            }
            apu = (tz0 - tc_apu) * L;
            d_elements[hook(1, N2 + ii - nnn)] = (apu);
            d_indices[hook(0, N2 + ii - nnn)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
            temp += apu;
            nnn--;
            for (int nl = nnn; nl >= 0; nl--) {
              if (apu_bool) {
                tx0_apu -= txu;
                apu_tempi -= iu;
                if (tx0_apu - txu >= ty0_apu - tyu && nl > 0) {
                  tc_apu = tx0_apu - txu;
                } else if (nl > 0) {
                  tc_apu = ty0_apu - tyu;
                  apu_bool = false;
                } else
                  tc_apu = tc;
                apu = (tx0_apu - tc_apu) * L;
              } else {
                ty0_apu -= tyu;
                apu_tempj -= ju;
                if (tx0_apu - txu >= ty0_apu - tyu && nl > 0) {
                  tc_apu = tx0_apu - txu;
                  apu_bool = true;
                } else if (nl > 0) {
                  tc_apu = ty0_apu - tyu;
                } else
                  tc_apu = tc;
                apu = (ty0_apu - tc_apu) * L;
              }
              d_indices[hook(0, N2 + ii - nl)] = apu_tempj * *d_Nx + apu_tempi + *d_Nx * *d_Ny * tempk;
              d_elements[hook(1, N2 + ii - nl)] = (apu);
              temp += apu;
            }
            apu_varx = false;
            apu_vary = false;
            nnn = 0;
            first_y = false;
          } else {
            double tc_apu2 = tc;
            if (apu_varx2) {
              apu_tempi = tempi;
              tx0_apu = tx0;
              for (int kk = 0; kk < (nnx); kk++) {
                tx0_apu -= txu;
                apu_tempi -= iu;
              }
              for (int nlx = 0; nlx < (nnx); nlx++) {
                d_indices[hook(0, N2 + ii - (nnx - nlx))] = tempj * *d_Nx + apu_tempi + *d_Nx * *d_Ny * tempk;
                apu_tempi += iu;
                apu = (tx0_apu - tc_apu2) * L;
                d_elements[hook(1, N2 + ii - (nnx - nlx))] = (apu);
                temp += apu;
                tc_apu2 = tx0_apu;
                tx0_apu += txu;
              }
              apu_varx2 = false;
              nnx = 0;
              first_y = false;
              first_x = false;
            }
            d_indices[hook(0, N2 + ii)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
            apu = ((tz0 - tc_apu2) * L);
            d_elements[hook(1, N2 + ii)] = apu;
            temp += apu;
          }
          tempk += ku;
          tc = tz0;
          tz0 += tzu;
        } else if (ty0 < tx0) {
          if (ju > 0) {
            if (apu_varx) {
              apu_tempi = tempi;
              tx0_apu = tx0;
              tc_apu = tx0 - txu;
              for (int nl = nnn; nl >= 0; nl--) {
                d_indices[hook(0, N2 + ii - nl)] = tempj * *d_Nx + apu_tempi + *d_Nx * *d_Ny * tempk;
                if (nl == nnn)
                  apu = (ty0 - tc_apu) * L;
                else if (nl == 0)
                  apu = (tx0_apu - tc) * L;
                else {
                  apu = (tx0_apu - tc_apu) * L;
                }
                d_elements[hook(1, N2 + ii - nl)] = (apu);
                temp += apu;
                apu_tempi -= iu;
                tx0_apu -= txu;
                tc_apu -= txu;
              }
              apu_varx = false;
              nnn = 0;
              tc = ty0;
            } else {
              d_indices[hook(0, N2 + ii)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
              apu = ((ty0 - tc) * L);
              d_elements[hook(1, N2 + ii)] = apu;
              temp += apu;
              tc = ty0;
            }
          } else {
            if (nnn == 0 || (apu_varx && apu_vary == false)) {
              apu_vary = true;
            }
            final_y = true;
            final_x = false;
            nnn++;
            nyy++;
            if (first_y == false && first_x == false)
              first_y = true;
          }
          tempj += ju;
          ty0 += tyu;
        } else {
          if (iu > 0) {
            if (ju < 0 && ii < Np - 1) {
              apu_varx2 = true;
              nnx++;
              final_x = true;
              final_y = false;
              if (first_y == false && first_x == false)
                first_x = true;
            } else if (ii == Np - 1 && apu_varx2) {
              if (final_x) {
                tc_apu = tc;
                apu_tempi = tempi;
                tx0_apu = tx0;
                apu_tempj = tempj;
                ty0_apu = ty0;
              } else {
                apu_tempj = tempj - ju;
                ty0_apu = ty0 - tyu;
                apu_tempi = tempi;
                tx0_apu = tx0;
                apu = (tx0 - ty0_apu) * L;
                d_elements[hook(1, N2 + ii - nnn - nnx)] = (apu);
                d_indices[hook(0, N2 + ii - nnn - nnx)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
                nnn--;
                temp += apu;
              }
              double tx0_apu2 = tx0_apu;
              double tc_apu2 = tc_apu;
              int apu_tempi2 = tempi;
              for (int nl = nnn; nl >= 0; nl--) {
                int nnnx = 0;
                bool nxn = false;
                while (tx0_apu2 - txu > ty0_apu - tyu && nnnx < nnx) {
                  nnnx++;
                  tx0_apu2 -= txu;
                  apu_tempi2 -= iu;
                }
                if (nl == 0 && first_x) {
                  tc_apu2 = tc;
                } else if (nnnx > 0)
                  tc_apu2 = ty0_apu - tyu;
                double tx0_apu3 = tx0_apu2;
                int apu_tempi3 = apu_tempi2;
                if (nnnx > 0) {
                  for (int nlx = 0; nlx < nnnx; nlx++) {
                    d_indices[hook(0, N2 + ii - nl - (nnx - nlx))] = apu_tempj * *d_Nx + apu_tempi2 + *d_Nx * *d_Ny * tempk;
                    apu = (tx0_apu2 - tc_apu2) * L;
                    d_elements[hook(1, N2 + ii - nl - (nnx - nlx))] = (apu);
                    temp += apu;
                    tc_apu2 = tx0_apu2;
                    if (nlx < nnnx - 1) {
                      apu_tempi2 += iu;
                      tx0_apu2 += txu;
                    }
                  }
                  nnx -= nnnx;
                  nxn = true;
                  tx0_apu2 = tx0_apu3;
                  apu_tempi2 = apu_tempi3;
                  apu_tempi3 += nnnx * iu;
                }
                if (nxn)
                  d_indices[hook(0, N2 + ii - nl - nnx)] = apu_tempj * *d_Nx + apu_tempi3 + *d_Nx * *d_Ny * tempk;
                else
                  d_indices[hook(0, N2 + ii - nl - nnx)] = apu_tempj * *d_Nx + apu_tempi2 + *d_Nx * *d_Ny * tempk;
                if ((nnnx > 0 && nl > 0) || (nl == 0 && nnnx > 0)) {
                } else if (nl > 0) {
                  tc_apu2 = ty0_apu - tyu;
                } else if (first_y) {
                  tc_apu2 = tc;
                }
                if (nl == nnn && final_x)
                  apu = (tx0_apu - tc_apu2) * L;
                else
                  apu = (ty0_apu - tc_apu2) * L;
                d_elements[hook(1, N2 + ii - nl - nnx)] = (apu);
                temp += apu;
                apu_tempj -= ju;
                ty0_apu -= tyu;
              }
              apu_vary = false;
              nnn = 0;
              apu_varx2 = false;
              nnx = 0;
              first_x = false;
              first_y = false;
            } else if (ii == Np - 1 && apu_varx2 == false && apu_vary == false) {
              d_indices[hook(0, N2 + ii)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
              apu = ((tx0 - tc) * L);
              d_elements[hook(1, N2 + ii)] = apu;
              temp += apu;
            } else if (apu_vary && apu_varx2 == false) {
              apu_tempj = tempj;
              ty0_apu = ty0;
              tc_apu = ty0_apu - tyu;
              for (int nl = nnn; nl >= 0; nl--) {
                d_indices[hook(0, N2 + ii - nl)] = apu_tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
                if (nl == nnn) {
                  apu = (tx0 - tc_apu) * L;
                } else if (nl == 0)
                  apu = (ty0_apu - tc) * L;
                else {
                  apu = (ty0_apu - tc_apu) * L;
                }
                d_elements[hook(1, N2 + ii - nl)] = (apu);
                temp += apu;
                apu_tempj -= ju;
                ty0_apu -= tyu;
                tc_apu -= tyu;
              }
              apu_vary = false;
              nnn = 0;
              tc = tx0;
              first_y = false;
            } else {
              d_indices[hook(0, N2 + ii)] = tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
              apu = ((tx0 - tc) * L);
              d_elements[hook(1, N2 + ii)] = apu;
              temp += apu;
              tc = tx0;
            }
          } else {
            if (nnn == 0 || (apu_vary && apu_varx == false)) {
              apu_varx = true;
            }
            final_y = false;
            final_x = true;
            nnn++;
            nxx++;
          }
          tempi += iu;
          tx0 += txu;
        }
        if (ii < (Np - 1) && tempj >= *d_Ny) {
          n_y = true;
          n_y_n++;
        }
        if (ii < (Np - 1) && tempi >= *d_Nx) {
          n_x = true;
          n_x_n++;
        }
        if (ii < (Np - 1) && tempk >= *d_Nz) {
          n_z = true;
          n_z_n++;
        }
        if (ii == Np - 1 && apu_varx && apu_vary == false) {
          apu_tempi = tempi - iu;
          tx0_apu = tx0 - txu;
          tc_apu = tx0_apu - txu;
          for (int nl = nnn - 1; nl >= 0; nl--) {
            d_indices[hook(0, N2 + ii - nl)] = tempj * *d_Nx + apu_tempi + *d_Nx * *d_Ny * tempk;
            if (nl == 0) {
              apu = (tx0_apu - tc) * L;
            } else {
              apu = (tx0_apu - tc_apu) * L;
            }
            d_elements[hook(1, N2 + ii - nl)] = (apu);
            temp += apu;
            if (nnn > 1) {
              apu_tempi -= iu;
              tx0_apu -= txu;
              tc_apu -= txu;
            }
          }
          apu_varx = false;
          nnn = 0;
        } else if (ii == Np - 1 && apu_vary && apu_varx == false) {
          if (apu_varx2) {
            apu_tempj = tempj - ju;
            ty0_apu = ty0 - tyu;
            apu_tempi = tempi;
            tx0_apu = tx0;
            double tx0_apu2 = tx0_apu;
            double tc_apu2 = tc_apu;
            int apu_tempi2 = tempi;
            for (int nl = nnn - 1; nl >= 0; nl--) {
              int nnnx = 0;
              bool nxn = false;
              while (tx0_apu2 - txu > ty0_apu - tyu && nnnx < nnx) {
                nnnx++;
                tx0_apu2 -= txu;
                apu_tempi2 -= iu;
              }
              if (nl == 0 && first_x)
                tc_apu2 = tc;
              else if (nnnx > 0)
                tc_apu2 = ty0_apu - tyu;
              double tx0_apu3 = tx0_apu2;
              int apu_tempi3 = apu_tempi2;
              if (nnnx > 0) {
                for (int nlx = 0; nlx < nnnx; nlx++) {
                  d_indices[hook(0, N2 + ii - nl - (nnx - nlx))] = apu_tempj * *d_Nx + apu_tempi2 + *d_Nx * *d_Ny * tempk;
                  apu = (tx0_apu2 - tc_apu2) * L;
                  d_elements[hook(1, N2 + ii - nl - (nnx - nlx))] = (apu);
                  temp += apu;
                  tc_apu2 = tx0_apu2;
                  if (nlx < nnnx - 1) {
                    apu_tempi2 += iu;
                    tx0_apu2 += txu;
                  }
                }
                nnx -= nnnx;
                nxn = true;
                tx0_apu2 = tx0_apu3;
                apu_tempi2 = apu_tempi3;
                apu_tempi3 += nnnx * iu;
              }
              if (nxn) {
                d_indices[hook(0, N2 + ii - nl - nnx)] = apu_tempj * *d_Nx + apu_tempi3 + *d_Nx * *d_Ny * tempk;
              } else {
                d_indices[hook(0, N2 + ii - nl - nnx)] = apu_tempj * *d_Nx + apu_tempi2 + *d_Nx * *d_Ny * tempk;
              }
              if ((nnnx > 0 && nl > 0) || (nl == 0 && nnnx > 0)) {
              } else if (nl > 0) {
                tc_apu2 = ty0_apu - tyu;
              } else if (first_y) {
                tc_apu2 = tc;
              }
              apu = (ty0_apu - tc_apu2) * L;
              d_elements[hook(1, N2 + ii - nl - nnx)] = (apu);
              temp += apu;
              ty0_apu -= tyu;
              apu_tempj -= ju;
            }
            apu_vary = false;
            nnn = 0;
            apu_varx2 = false;
            nnx = 0;
            first_y = false;
            first_x = false;
          } else {
            apu_tempj = tempj - ju;
            ty0_apu = ty0 - tyu;
            tc_apu = ty0_apu - tyu;
            for (int nl = nnn - 1; nl >= 0; nl--) {
              d_indices[hook(0, N2 + ii - nl)] = apu_tempj * *d_Nx + tempi + *d_Nx * *d_Ny * tempk;
              if (nl == 0)
                apu = (ty0_apu - tc) * L;
              else {
                apu = (ty0_apu - tc_apu) * L;
              }
              d_elements[hook(1, N2 + ii - nl)] = (apu);
              temp += apu;
              if (nnn > 1) {
                apu_tempj -= ju;
                ty0_apu -= tyu;
                tc_apu -= tyu;
              }
            }
            apu_vary = false;
            nnn = 0;
          }
        } else if (ii == Np - 1 && apu_varx && apu_vary) {
          bool apu_bool = false;
          if (final_x) {
            apu_tempi = tempi - iu;
            tx0_apu = tx0 - txu;
            apu_tempj = tempj;
            ty0_apu = ty0;
            if (tx0_apu - txu >= ty0_apu - tyu && nnn > 1) {
              tc_apu = tx0_apu - txu;
              apu_bool = true;
            } else if (nnn > 1)
              tc_apu = ty0_apu - tyu;
            else
              tc_apu = tc;
            apu = (tx0_apu - tc_apu) * L;
          } else {
            apu_tempj = tempj - ju;
            ty0_apu = ty0 - tyu;
            apu_tempi = tempi;
            tx0_apu = tx0;
            if (tx0_apu - txu >= ty0_apu - tyu && nnn > 1) {
              tc_apu = tx0_apu - txu;
              apu_bool = true;
            } else if (nnn > 1)
              tc_apu = ty0_apu - tyu;
            else
              tc_apu = tc;
            apu = (ty0_apu - tc_apu) * L;
          }
          for (int nl = nnn - 1; nl >= 0; nl--) {
            d_indices[hook(0, N2 + ii - nl)] = apu_tempj * *d_Nx + apu_tempi + *d_Nx * *d_Ny * tempk;
            d_elements[hook(1, N2 + ii - nl)] = (apu);
            temp += apu;
            if (apu_bool && nl > 0) {
              tx0_apu -= txu;
              apu_tempi -= iu;
              if (tx0_apu - txu >= ty0_apu - tyu && nl > 1) {
                tc_apu = tx0_apu - txu;
              } else if (nl > 1) {
                tc_apu = ty0_apu - tyu;
                apu_bool = false;
              } else
                tc_apu = tc;
              apu = (tx0_apu - tc_apu) * L;
            } else if (nl > 0) {
              ty0_apu -= tyu;
              apu_tempj -= ju;
              if (tx0_apu - txu >= ty0_apu - tyu && nl > 1) {
                tc_apu = tx0_apu - txu;
                apu_bool = true;
              } else if (nl > 1) {
                tc_apu = ty0_apu - tyu;
              } else
                tc_apu = tc;
              apu = (ty0_apu - tc_apu) * L;
            }
          }
        }
      }
      if (n_x) {
        for (int ii = 0; ii <= n_x_n; ii++) {
          d_indices[hook(0, N2 + Np - ii - 1)] -= 1;
          if (ii == n_x_n)
            d_indices[hook(0, N2 + Np - ii - 2)] -= (*d_Nx - 1);
        }
      }
      if (n_y) {
        for (int ii = 0; ii <= n_y_n; ii++) {
          if (ii == 0)
            d_indices[hook(0, N2 + Np - 1)] -= *d_Nx;
          else {
            if (d_indices[hook(0, N2 + Np - 1 - ii)] - 1 > d_indices[hook(0, N2 + Np - ii)])
              d_indices[hook(0, N2 + Np - 1 - ii)] -= (*d_Nx - 1);
            else
              d_indices[hook(0, N2 + Np - 1 - ii)] -= 1;
          }
        }
        if (d_indices[hook(0, N2 + Np - 1 - n_y_n)] == d_indices[hook(0, N2 + Np - 2 - n_y_n)])
          d_indices[hook(0, N2 + Np - 2 - n_y_n)] -= 1;
      }
      if (n_z) {
        for (int ii = 0; ii <= n_z_n; ii++) {
          if (ii == 0)
            d_indices[hook(0, N2 + Np - 1)] -= (*d_Nx * *d_Ny);
          else {
            if (d_indices[hook(0, N2 + Np - 1 - ii)] - 1 > d_indices[hook(0, N2 + Np - ii)])
              d_indices[hook(0, N2 + Np - 1 - ii)] -= (*d_Nx * *d_Ny - 1);
            else
              d_indices[hook(0, N2 + Np - 1 - ii)] -= 1;
          }
        }
        if (d_indices[hook(0, N2 + Np - 1 - n_z_n)] == d_indices[hook(0, N2 + Np - 2 - n_z_n)])
          d_indices[hook(0, N2 + Np - 2 - n_z_n)] -= 1;
      }
      temp = 1. / temp;
      if (*d_attenuation_correction == 1) {
        double jelppi = 0.;
        for (int iii = 0; iii < Np; iii++) {
          jelppi += (d_elements[hook(1, N2 + iii)] * (-d_atten[hook(36, d_indices[Nhook(0, N2 + iii))]));
        }
        temp = exp(jelppi) * temp;
      }
      for (int ii = 0; ii < Np; ii++) {
        d_elements[hook(1, N2 + ii)] *= temp;
      }
    }
  }
}