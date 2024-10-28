//{"dg":5,"flux":8,"istar":1,"ks":0,"ldw":4,"ng":7,"npb":6,"pbids":3,"zs":2}
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
    float iplanet = (1.0f - ag) * ldw[hook(4, ig)] + ag * ldw[hook(4, ig + 1)];
    float aplanet = circle_circle_intersection_area(1.0f, k, g * (1.0f + k));
    return (istar - iplanet * aplanet) / istar;
  } else {
    return 1.0f;
  }
}

kernel void ptmodel_z(global const float* ks, const float istar, global const float* zs, global const int* pbids, global const float* ldw, const float dg, const int npb, const int ng, global float* flux) {
  int ipv = get_global_id(0);
  int npv = get_global_size(0);
  int iz = get_global_id(1);
  int nz = get_global_size(1);
  unsigned int gid = ipv * nz + iz;

  int ipb = pbids[hook(3, iz)];
  float k = ks[hook(0, ipv)];
  float g = zs[hook(2, iz)] / (1.0f + k);

  flux[hook(8, gid)] = swiftmodel_flux(g, k, istar, &ldw[hook(4, ipv * npb * ng + ipb * ng)], dg);
}