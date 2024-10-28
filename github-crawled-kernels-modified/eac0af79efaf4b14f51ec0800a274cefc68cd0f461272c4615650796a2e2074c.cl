//{"ldp":1,"ldw":3,"nz":0,"weights":2}
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

kernel void calculate_ldw(const unsigned int nz, global const float* ldp, global const float* weights, global float* ldw) {
  int ipv = get_global_id(0);
  int npv = get_global_size(0);
  int ipb = get_global_id(1);
  int npb = get_global_size(1);
  int ig = get_global_id(2);
  int ng = get_global_size(2);
  unsigned int gid = ipv * npb * ng + ipb * ng + ig;

  unsigned int iw = ipv * ng * nz + ig * nz;
  unsigned int il = ipv * npb * nz + ipb * nz;

  ldw[hook(3, gid)] = 0.0f;
  for (unsigned int i = 0; i < nz; i++) {
    ldw[hook(3, gid)] += weights[hook(2, iw + i)] * ldp[hook(1, il + i)];
  }
}