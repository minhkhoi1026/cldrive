//{"dg":4,"exptimes":9,"flux":13,"istar":1,"ks":15,"lcids":5,"ldw":2,"ng":3,"nlc":11,"npb":12,"nss":8,"pbids":6,"pv":14,"pv_length":10,"pv_pop":7,"times":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float TWO_PI = 2 * 3.14159265358979323846264338327950288f;
constant float HALF_PI = 1.57079632679489661923132169163975144f;
float mean_anomaly_offset(const float e, const float w) {
  float offset = atan2(sqrt(1.0f - e * e) * sin(HALF_PI - w), e + cos(HALF_PI - w));
  return offset - e * sin(offset);
}

float z_iter(const float t, const float t0, const float p, const float a, const float i, const float e, const float w, const float ma_offset, const float eclipse) {
  float Ma, ec, ect, Ea, sta, cta, Ta, z;

  Ma = fmod(TWO_PI * (t - (t0 - ma_offset * p / TWO_PI)) / p, TWO_PI);
  ec = e * sin(Ma) / (1.f - e * cos(Ma));

  for (int i = 0; i < 15; i++) {
    ect = ec;
    ec = e * sin(Ma + ec);
    if (fabs(ect - ec) < 1e-4) {
      break;
    }
  }
  Ea = Ma + ec;
  sta = sqrt(1.f - e * e) * sin(Ea) / (1.f - e * cos(Ea));
  cta = (cos(Ea) - e) / (1.f - e * cos(Ea));
  Ta = atan2(sta, cta);

  if (eclipse * sign(sin(w + Ta)) > 0.0f) {
    return a * (1.f - e * e) / (1.f + e * cos(Ta)) * sqrt(1.f - pow(sin(w + Ta) * sin(i), 2));
  } else {
    return -1.f;
  }
}

float circle_circle_intersection_area(float r1, float r2, float b) {
  if (r1 < b - r2) {
    return 0.0f;
  } else if (r1 >= b + r2) {
    return 3.14159265358979323846264338327950288f * r2 * r2;
  } else if (b - r2 <= -r1) {
    return 3.14159265358979323846264338327950288f * r1 * r1;
  } else {
    return r2 * r2 * acos((b * b + r2 * r2 - r1 * r1) / (2 * b * r2)) + r1 * r1 * acos((b * b + r1 * r1 - r2 * r2) / (2 * b * r1)) - 0.5f * sqrt((-b + r2 + r1) * (b + r2 - r1) * (b - r2 + r1) * (b + r2 + r1));
  }
}

float swiftmodel_flux(const float g, const float k, const float istar, global const float* ldw, const float dg) {
  if (g < 1.0f) {
    float ag = g / dg;
    unsigned int ig = floor(ag);
    ag -= ig;
    float iplanet = (1.0f - ag) * ldw[hook(2, ig)] + ag * ldw[hook(2, ig + 1)];
    float aplanet = circle_circle_intersection_area(1.0f, k, g * (1.0f + k));
    return (istar - iplanet * aplanet) / istar;
  } else {
    return 1.0f;
  }
}

kernel void swift_pop(global const float* times, global const float* istar, global const float* ldw, const unsigned int ng, const float dg, global const unsigned int* lcids, global const unsigned int* pbids, global const float* pv_pop, global const unsigned int* nss, global const float* exptimes, const unsigned int pv_length, const unsigned int nlc, const unsigned int npb, global float* flux) {
  unsigned int i_tm = get_global_id(1);
  unsigned int n_tm = get_global_size(1);
  unsigned int i_pv = get_global_id(0);
  unsigned int n_pv = get_global_size(0);
  unsigned int gid = i_pv * n_tm + i_tm;
  unsigned int lcid = lcids[hook(5, i_tm)];
  unsigned int pbid = pbids[hook(6, lcid)];
  unsigned int nks = pv_length - 6;

  global const float* ks = &pv_pop[hook(7, i_pv * pv_length)];
  global const float* pv = &pv_pop[hook(7, i_pv * pv_length + nks)];

  unsigned int ns = nss[hook(8, lcid)];
  float exptime = exptimes[hook(9, lcid)];
  float toffset, z;
  float ma_offset = mean_anomaly_offset(pv[hook(14, 4)], pv[hook(14, 5)]);
  float k = ks[hook(15, 0)];

  if (nks > 1) {
    if (pbid < nks) {
      k = ks[hook(15, pbid)];
    } else {
      flux[hook(13, gid)] = __builtin_astype((2147483647), float);
      return;
    }
  }

  flux[hook(13, gid)] = 0.0f;
  for (int i = 1; i < ns + 1; i++) {
    toffset = exptime * (((float)i - 0.5f) / (float)ns - 0.5f);
    z = z_iter(times[hook(0, i_tm)] + toffset, pv[hook(14, 0)], pv[hook(14, 1)], pv[hook(14, 2)], pv[hook(14, 3)], pv[hook(14, 4)], pv[hook(14, 5)], ma_offset, 1.0f);
    flux[hook(13, gid)] += swiftmodel_flux(z / (1.0f + k), k, istar[hook(1, i_pv * npb + pbid)], &ldw[hook(2, i_pv * npb * ng + pbid * ng)], dg);
  }
  flux[hook(13, gid)] /= (float)ns;
}