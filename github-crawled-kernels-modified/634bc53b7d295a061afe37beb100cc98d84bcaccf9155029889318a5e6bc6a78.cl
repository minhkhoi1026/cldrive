//{"exptimes":6,"flux":10,"ks":13,"lcids":1,"ldc_pop":4,"nlc":8,"npb":9,"nss":5,"pbids":2,"pv":12,"pv_length":7,"pv_pop":3,"times":0,"u":11}
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

float q1n(float z, float p, float c, float alpha, float g, float I_0) {
  float s = 1.0f - z * z;
  float c0 = (1.0f - c + c * pow(s, g));
  float c2 = 0.5f * alpha * c * pow(s, g - 2.0f) * ((alpha - 1.0f) * z * z - 1.f);
  return 1.f - I_0 * 3.14159265358979323846264338327950288f * p * p * (c0 + 0.25f * p * p * c2 - 0.125f * alpha * c * p * p * pow(s, g - 1));
}

float q2n(float z, float p, float c, float alpha, float g, float I_0) {
  float d = (z * z - p * p + 1.0f) / (2.0f * z);
  float ra = 0.5f * (z - p + d);
  float rb = 0.5f * (1 + d);
  float sa = 1.0f - ra * ra;
  float sb = 1.0 - rb * rb;
  float q = (z - d) / p;
  float w2 = p * p - pown(d - z, 2);
  float w = sqrt(w2);
  float b0 = 1.0f - c + c * pow(sa, g);
  float b1 = -alpha * c * ra * pow(sa, g - 1.0f);
  float b2 = 0.5f * alpha * c * pow(sa, g - 2.0f) * ((alpha - 1) * ra * ra - 1.0f);
  float a0 = b0 + b1 * (z - ra) + b2 * pown(z - ra, 2);
  float a1 = b1 + 2 * b2 * (z - ra);
  float aq = acos(q);
  float J1 = (a0 * (d - z) - (2.0f / 3.0f) * a1 * w2 + 0.25f * b2 * (d - z) * (2 * pown(d - z, 2) - p * p)) * w + (a0 * p * p + 0.25f * b2 * pown(p, 4)) * aq;
  float J2 = alpha * c * pow(sa, g - 1.0f) * pown(p, 4) * (0.125f * aq + (1.0f / 12.0f) * q * (q * q - 2.5f) * sqrt(1.0f - q * q));
  float d0 = 1 - c + c * pow(sb, g);
  float d1 = -alpha * c * rb * pow(sb, g - 1.0f);
  float K1 = ((d0 - rb * d1) * acos(d) + ((rb * d + (2.0f / 3.0f) * (1.0f - d * d)) * d1 - d * d0) * sqrt(1.0f - d * d));
  float K2 = (1.0f / 3.0f) * c * alpha * pow(sb, g + 0.5f) * (1.0f - d);
  return 1.0f - I_0 * (J1 - J2 + K1 - K2);
}

float eval_qpower2(float z, float k, global const float* u) {
  float I_0 = (u[hook(11, 1)] + 2.0f) / (3.14159265358979323846264338327950288f * (u[hook(11, 1)] - u[hook(11, 0)] * u[hook(11, 1)] + 2.0f));
  float g = 0.5f * u[hook(11, 1)];
  float flux = 1.0f;
  if (z >= 0.0f) {
    if (z <= 1.0f - k) {
      flux = q1n(z, k, u[hook(11, 0)], u[hook(11, 1)], g, I_0);
    } else if (fabs(z - 1.0f) < k) {
      flux = q2n(z, k, u[hook(11, 0)], u[hook(11, 1)], g, I_0);
    }
  }
  return flux;
}

kernel void qpower2_eccentric_pop(global const float* times, global const unsigned int* lcids, global const unsigned int* pbids, global const float* pv_pop, global const float* ldc_pop, global const unsigned int* nss, global const float* exptimes, unsigned int pv_length, unsigned int nlc, unsigned int npb, global float* flux) {
  unsigned int i_tm = get_global_id(1);
  unsigned int n_tm = get_global_size(1);
  unsigned int i_pv = get_global_id(0);
  unsigned int n_pv = get_global_size(0);
  unsigned int gid = i_pv * n_tm + i_tm;
  unsigned int lcid = lcids[hook(1, i_tm)];
  unsigned int pbid = pbids[hook(2, lcid)];
  unsigned int nks = pv_length - 6;

  global const float* ks = &pv_pop[hook(3, i_pv * pv_length)];
  global const float* pv = &pv_pop[hook(3, i_pv * pv_length + nks)];
  global const float* ldc = &ldc_pop[hook(4, 2 * npb * i_pv + 2 * pbid)];

  unsigned int ns = nss[hook(5, lcid)];
  float exptime = exptimes[hook(6, lcid)];
  float toffset, z;
  float ma_offset = mean_anomaly_offset(pv[hook(12, 4)], pv[hook(12, 5)]);
  float k = ks[hook(13, 0)];

  if (nks > 1) {
    if (pbid < nks) {
      k = ks[hook(13, pbid)];
    } else {
      flux[hook(10, gid)] = __builtin_astype((2147483647), float);
      return;
    }
  }

  flux[hook(10, gid)] = 0.0f;
  for (int i = 1; i < ns + 1; i++) {
    toffset = exptime * (((float)i - 0.5f) / (float)ns - 0.5f);
    z = z_iter(times[hook(0, i_tm)] + toffset, pv[hook(12, 0)], pv[hook(12, 1)], pv[hook(12, 2)], pv[hook(12, 3)], pv[hook(12, 4)], pv[hook(12, 5)], ma_offset, 1.0f);
    flux[hook(10, gid)] += eval_qpower2(z, k, ldc);
  }
  flux[hook(10, gid)] /= (float)ns;
}