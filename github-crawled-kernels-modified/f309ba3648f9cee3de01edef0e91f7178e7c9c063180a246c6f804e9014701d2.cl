//{"cutsq":4,"eatom":16,"eflag":0,"f_data":15,"ilist0":2,"inum":1,"lj1":9,"lj2":10,"lj3":11,"lj4":12,"nall":3,"nndata":7,"nndataoffset":6,"numneigh":5,"offset":13,"special_lj":14,"vtmp":17,"x_data":8}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pair_lj_cut_kern(int eflag, int inum, int ilist0, int nall, double cutsq, global int* numneigh, global int* nndataoffset, global int* nndata, global double* x_data, double lj1, double lj2, double lj3, double lj4, double offset, read_only image2d_t special_lj, global double* f_data, global double* eatom, global double* vtmp) {
  const sampler_t sampler0 = 0 | 0 | 0x10;

  int gti = get_global_id(0);

  if (gti < inum) {
    int i = gti + ilist0;

    double xtmp = x_data[hook(8, i * 3 + 0)];
    double ytmp = x_data[hook(8, i * 3 + 1)];
    double ztmp = x_data[hook(8, i * 3 + 2)];

    int offset = nndataoffset[hook(6, gti)];

    int jnum = numneigh[hook(5, gti)];

    double tmpx = 0.0;
    double tmpy = 0.0;
    double tmpz = 0.0;
    double tmpe = 0.0;
    double vtmp0 = 0.0;
    double vtmp1 = 0.0;
    double vtmp2 = 0.0;
    double vtmp3 = 0.0;
    double vtmp4 = 0.0;
    double vtmp5 = 0.0;

    int jj;
    for (jj = 0; jj < jnum; jj++) {
      int j = nndata[hook(7, offset + jj)];

      double factor_lj;

      if (j < nall)
        factor_lj = 1.0;
      else {
        int m = j / nall;
        float4 c = read_imagef(special_lj, sampler0, (int2)(0, m));
        factor_lj = __builtin_astype((c.xy), double);
        j %= nall;
      }

      double delx = xtmp - x_data[hook(8, j * 3 + 0)];
      double dely = ytmp - x_data[hook(8, j * 3 + 1)];
      double delz = ztmp - x_data[hook(8, j * 3 + 2)];
      double rsq = delx * delx + dely * dely + delz * delz;

      if (rsq < cutsq) {
        double r2inv = 1.0 / rsq;
        double r6inv = r2inv * r2inv * r2inv;
        double forcelj = r6inv * (lj1 * r6inv - lj2);
        double fpair = factor_lj * forcelj * r2inv;

        tmpx += delx * fpair;
        tmpy += dely * fpair;
        tmpz += delz * fpair;

        if (eflag == 1) {
          double evdwl = r6inv * (lj3 * r6inv - lj4) - offset;
          evdwl *= factor_lj;
          tmpe += evdwl;

          vtmp0 += 0.5 * delx * delx * fpair;
          vtmp1 += 0.5 * dely * dely * fpair;
          vtmp2 += 0.5 * delz * delz * fpair;
          vtmp3 += 0.5 * delx * dely * fpair;
          vtmp4 += 0.5 * delx * delz * fpair;
          vtmp5 += 0.5 * dely * delz * fpair;
        }
      }
    }

    f_data[hook(15, i * 3 + 0)] = tmpx;
    f_data[hook(15, i * 3 + 1)] = tmpy;
    f_data[hook(15, i * 3 + 2)] = tmpz;

    if (eflag == 1) {
      eatom[hook(16, i)] = tmpe;
      vtmp[hook(17, i * 6 + 0)] = vtmp0;
      vtmp[hook(17, i * 6 + 1)] = vtmp1;
      vtmp[hook(17, i * 6 + 2)] = vtmp2;
      vtmp[hook(17, i * 6 + 3)] = vtmp3;
      vtmp[hook(17, i * 6 + 4)] = vtmp4;
      vtmp[hook(17, i * 6 + 5)] = vtmp5;
    }
  }
}