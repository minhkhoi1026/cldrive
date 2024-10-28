//{"Neffect_radius":7,"Nq":3,"background":9,"cutoff":6,"loops":5,"loops_g":4,"qx":0,"qy":1,"result":2,"scale":8,"volfraction":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float form_volume(float effect_radius);
float form_volume(float effect_radius) {
  return 1.0f;
}

float Iq(float q, float effect_radius, float volfraction);
float Iq(float q, float effect_radius, float volfraction) {
  float denom, dnum, alpha, beta, gamm, a, asq, ath, afor, rca, rsa;
  float calp, cbeta, cgam, prefac, c, vstruc;
  float struc;

  denom = pow((1.0f - volfraction), 4);
  dnum = pow((1.0f + 2.0f * volfraction), 2);
  alpha = dnum / denom;
  beta = -6.0f * volfraction * pow((1.0f + volfraction / 2.0f), 2) / denom;
  gamm = 0.50f * volfraction * dnum / denom;

  a = 2.0f * q * effect_radius;
  asq = a * a;
  ath = asq * a;
  afor = ath * a;
  do {
    const float _t_ = a;
    rsa = sin(_t_);
    rca = cos(_t_);
  } while (0);

  calp = alpha * (rsa / asq - rca / a);
  cbeta = beta * (2.0f * rsa / asq - (asq - 2.0f) * rca / ath - 2.0f / ath);
  cgam = gamm * (-rca / a + (4.0f / a) * ((3.0f * asq - 6.0f) * rca / afor + (asq - 6.0f) * rsa / ath + 6.0f / afor));
  prefac = -24.0f * volfraction / a;
  c = prefac * (calp + cbeta + cgam);
  vstruc = 1.0f / (1.0f - c);
  struc = vstruc;

  return (struc);
}

float Iqxy(float qx, float qy, float effect_radius, float volfraction);
float Iqxy(float qx, float qy, float effect_radius, float volfraction) {
  return Iq(sqrt(qx * qx + qy * qy), effect_radius, volfraction);
}
kernel void hardsphere_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq,

                            global float* loops_g,

                            local float* loops, const float cutoff, const int Neffect_radius,

                            const float scale, const float background, const float volfraction) {
  event_t e = async_work_group_copy(loops, loops_g, (Neffect_radius)*2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int effect_radius_i = 0; effect_radius_i < Neffect_radius; effect_radius_i++) {
      const float effect_radius = loops[hook(5, 2 * (effect_radius_i))];
      const float effect_radius_w = loops[hook(5, 2 * (effect_radius_i) + 1)];

      const float weight = effect_radius_w;
      if (weight > cutoff) {
        const float scattering = Iqxy(qxi, qyi, effect_radius, volfraction);
        if (!isnan(scattering)) {
          const float next = weight * scattering;

          ret += next;

          norm += weight;

          const float vol_weight = effect_radius_w;
          vol += vol_weight * form_volume(effect_radius);

          norm_vol += vol_weight;
        }
      }
    }

    if (vol * norm_vol != 0.0f) {
      ret *= norm_vol / vol;
    }

    result[hook(2, i)] = scale * ret / norm + background;
  }
}