//{"Nq":2,"Nradius":6,"background":8,"cutoff":5,"loops":4,"loops_g":3,"q":0,"result":1,"scale":7,"sld":9,"solvent_sld":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sph_j1c(float q);
float sph_j1c(float q) {
  const float q2 = q * q;
  float sin_q, cos_q;

  do {
    const float _t_ = q;
    sin_q = sin(_t_);
    cos_q = cos(_t_);
  } while (0);

  const float bessel = (q < 0.384038453352533f) ? (1.0f + q2 * (-3.f / 30.f + q2 * (3.f / 840.f))) : 3.0f * (sin_q / q - cos_q) / q2;

  return bessel;
}

float form_volume(float radius);
float form_volume(float radius) {
  return 1.333333333333333f * 3.14159265358979323846f * radius * radius * radius;
}

float Iq(float q, float sld, float solvent_sld, float radius);
float Iq(float q, float sld, float solvent_sld, float radius) {
  const float qr = q * radius;
  const float bes = sph_j1c(qr);
  const float fq = bes * (sld - solvent_sld) * form_volume(radius);
  return 1.0e-4f * fq * fq;
}

float Iqxy(float qx, float qy, float sld, float solvent_sld, float radius);
float Iqxy(float qx, float qy, float sld, float solvent_sld, float radius) {
  return Iq(sqrt(qx * qx + qy * qy), sld, solvent_sld, radius);
}
kernel void sphere_Iq(global const float* q, global float* result, const int Nq,

                      global float* loops_g,

                      local float* loops, const float cutoff, const int Nradius,

                      const float scale, const float background, const float sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Nradius)*2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int radius_i = 0; radius_i < Nradius; radius_i++) {
      const float radius = loops[hook(4, 2 * (radius_i))];
      const float radius_w = loops[hook(4, 2 * (radius_i) + 1)];

      const float weight = radius_w;
      if (weight > cutoff) {
        const float scattering = Iq(qi, sld, solvent_sld, radius);

        if (!isnan(scattering)) {
          ret += weight * scattering;
          norm += weight;

          const float vol_weight = radius_w;
          vol += vol_weight * form_volume(radius);
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