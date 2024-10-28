//{"Neffect_radius":6,"Nq":2,"background":8,"cutoff":5,"loops":4,"loops_g":3,"perturb":10,"q":0,"result":1,"scale":7,"stickiness":11,"volfraction":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float form_volume(float effect_radius);
float form_volume(float effect_radius) {
  return 1.0f;
}

float Iq(float q, float effect_radius, float volfraction, float perturb, float stickiness);
float Iq(float q, float effect_radius, float volfraction, float perturb, float stickiness) {
  float onemineps, eta;
  float sig, aa, etam1, etam1sq, qa, qb, qc, radic;
  float lam, lam2, test, mu, alpha, beta;
  float kk, k2, k3, ds, dc, aq1, aq2, aq3, aq, bq1, bq2, bq3, bq, sq;

  onemineps = 1.0f - perturb;
  eta = volfraction / onemineps / onemineps / onemineps;

  sig = 2.0f * effect_radius;
  aa = sig / onemineps;
  etam1 = 1.0f - eta;
  etam1sq = etam1 * etam1;

  qa = eta / 12.0f;
  qb = -1.0f * (stickiness + eta / etam1);
  qc = (1.0f + eta / 2.0f) / etam1sq;
  radic = qb * qb - 4.0f * qa * qc;
  if (radic < 0) {
    return (-1.0f);
  }

  lam = (-1.0f * qb - sqrt(radic)) / (2.0f * qa);
  lam2 = (-1.0f * qb + sqrt(radic)) / (2.0f * qa);
  if (lam2 < lam) {
    lam = lam2;
  }
  test = 1.0f + 2.0f * eta;
  mu = lam * eta * etam1;
  if (mu > test) {
    return (-1.0f);
  }
  alpha = (1.0f + 2.0f * eta - mu) / etam1sq;
  beta = (mu - 3.0f * eta) / (2.0f * etam1sq);

  kk = q * aa;
  k2 = kk * kk;
  k3 = kk * k2;
  do {
    const float _t_ = kk;
    ds = sin(_t_);
    dc = cos(_t_);
  } while (0);

  aq1 = ((ds - kk * dc) * alpha) / k3;
  aq2 = (beta * (1.0f - dc)) / k2;
  aq3 = (lam * ds) / (12.0f * kk);
  aq = 1.0f + 12.0f * eta * (aq1 + aq2 - aq3);

  bq1 = alpha * (0.5f / kk - ds / k2 + (1.0f - dc) / k3);
  bq2 = beta * (1.0f / kk - ds / k2);
  bq3 = (lam / 12.0f) * ((1.0f - dc) / kk);
  bq = 12.0f * eta * (bq1 + bq2 - bq3);

  sq = 1.0f / (aq * aq + bq * bq);

  return (sq);
}

float Iqxy(float qx, float qy, float effect_radius, float volfraction, float perturb, float stickiness);
float Iqxy(float qx, float qy, float effect_radius, float volfraction, float perturb, float stickiness) {
  return Iq(sqrt(qx * qx + qy * qy), effect_radius, volfraction, perturb, stickiness);
}
kernel void stickyhardsphere_Iq(global const float* q, global float* result, const int Nq,

                                global float* loops_g,

                                local float* loops, const float cutoff, const int Neffect_radius,

                                const float scale, const float background, const float volfraction, const float perturb, const float stickiness) {
  event_t e = async_work_group_copy(loops, loops_g, (Neffect_radius)*2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int effect_radius_i = 0; effect_radius_i < Neffect_radius; effect_radius_i++) {
      const float effect_radius = loops[hook(4, 2 * (effect_radius_i))];
      const float effect_radius_w = loops[hook(4, 2 * (effect_radius_i) + 1)];

      const float weight = effect_radius_w;
      if (weight > cutoff) {
        const float scattering = Iq(qi, effect_radius, volfraction, perturb, stickiness);

        if (!isnan(scattering)) {
          ret += weight * scattering;
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

    result[hook(1, i)] = scale * ret / norm + background;
  }
}