//{"beg_index":4,"buf_size":1,"buffer_process":0,"chn_num":6,"des_sr":8,"ori_sr":7,"out_buf":2,"out_samples":5,"out_size":3,"sinc_table":11,"sinc_table_":10,"w_hn":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int linear_interpolation_GPU(double ratio, int nL, int nR, int vL, int vR, double nI) {
  double dnL = nL, dnR = nR, dvL = vL, dvR = vR;

  if (ratio > 1.0)
    return 0;
  double dvI = dvL * (dnR - nI) + dvR * (nI - dnL);
  int vI = (int)dvI;
  return vI;
}

double windows_GPU(double t, double nT) {
  if (t <= nT && t >= -nT)
    return 0.42 + 0.5 * cos(3.14159265358979323846264338327950288f * t / nT) + 0.08 * cos(2 * 3.14159265358979323846264338327950288f * t / nT);
  else
    return 0;
}

double sinc_GPU(double t, double fs, double ratio) {
  if (ratio <= 1.0) {
    if (fabs(t) < (double)pow((double)10, (double)-30))
      return 1.0;
    double x = sin(fs * t * 3.14159265358979323846264338327950288f);
    double y = (3.14159265358979323846264338327950288f * fs * t);
    if (x / y > 1.0)
      return 1.0;
    return x / y;
  } else {
    double max = 1.0 / ratio;
    if (fabs(t) < (double)pow((double)10, (double)-30))
      return max;
    double x = sin(fs * t * 3.14159265358979323846264338327950288f * max);
    double y = (3.14159265358979323846264338327950288f * t * fs);
    if (x / y > max)
      return max;
    else
      return x / y;
  }
}

inline double lookup(double t, float* sinc_table) {
  t = fabs(t);
  t *= 512;
  int index = (int)(t);
  if (index > 65538)
    return 0.0;
  double sap = (double)sinc_table[hook(11, index)];

  double dt = (t - (double)index);
  double dt2 = (double)sinc_table[hook(11, index + 1)] - sap;
  return sap + dt * dt2;
}

kernel void interpolation(global float* buffer_process, int buf_size, global float* out_buf, int out_size, int beg_index, int out_samples, int chn_num, int ori_sr, int des_sr, int w_hn, global float* sinc_table_) {
  float* sinc_table = (float*)sinc_table_;
  int ix = get_global_id(0);
  if (ix > out_size)
    return;
  double ratio = (double)ori_sr / (double)des_sr;
  int ori_sample_rate = ori_sr;
  int des_sample_rate = des_sr;
  double rs_p_begin = (double)(out_samples + ix) * ratio;
  double ti = rs_p_begin;
  int nL = (int)rs_p_begin;
  int nR = nL + 1;

  int a_nL = nL - beg_index;
  int a_nR = nR - beg_index;
  if (a_nL > 4096 - w_hn) {
    return;
  }
  float vL = (a_nL >= 0 && a_nL <= 4096 - 1) ? buffer_process[hook(0, a_nL * chn_num)] : 0;
  float vR = (a_nR <= 4096 - 1 && a_nR >= 0) ? buffer_process[hook(0, a_nR * chn_num)] : 0;

  {
    double nIVL = 0;

    for (int i = 0; i < w_hn; i++) {
      int nId = a_nR + i;
      float vL = (nId >= 0 && nId <= 4096 - 1) ? buffer_process[hook(0, nId * chn_num)] : 0;
      int fabs_Index = nR + i;
      int index_f = fabs_Index;
      nIVL += (double)((double)vL * lookup(ti - (double)index_f, sinc_table));
    }
    for (int i = 0; i < w_hn; i++) {
      int nId = a_nL - i;
      float vL = (nId >= 0 && nId <= 4096 - 1) ? buffer_process[hook(0, nId * chn_num)] : 0;
      int fabs_Index = nL - i;
      int index_f = fabs_Index;
      nIVL += (double)((double)vL * lookup(ti - (double)index_f, sinc_table));
    }
    out_buf[hook(2, ix * chn_num)] = (float)nIVL;
  }
  {
    double nIVL = 0;

    for (int i = 0; i < w_hn; i++) {
      int nId = a_nR + i;
      float vL = (nId >= 0 && nId <= 4096 - 1) ? buffer_process[hook(0, nId * chn_num + 1)] : 0;
      int fabs_Index = nR + i;
      int index_f = fabs_Index;
      nIVL += (double)((double)vL * lookup(ti - (double)index_f, sinc_table));
    }
    for (int i = 0; i < w_hn; i++) {
      int nId = a_nL - i;
      float vL = (nId >= 0 && nId <= 4096 - 1) ? buffer_process[hook(0, nId * chn_num + 1)] : 0;
      int fabs_Index = nL - i;
      int index_f = fabs_Index;
      nIVL += (double)((double)vL * lookup(ti - (double)index_f, sinc_table));
    }
    out_buf[hook(2, ix * chn_num + 1)] = (float)nIVL;
  }

  return;
}