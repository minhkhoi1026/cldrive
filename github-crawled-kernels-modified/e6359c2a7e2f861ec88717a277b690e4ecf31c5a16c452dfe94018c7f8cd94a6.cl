//{"Nhead_length":7,"Nq":2,"Ntail_length":6,"background":9,"cutoff":5,"head_sld":11,"loops":4,"loops_g":3,"q":0,"result":1,"scale":8,"sld":10,"solvent_sld":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float form_volume(float tail_length, float head_length);
float form_volume(float tail_length, float head_length) {
  return 1.0f;
}

float Iq(float q, float tail_length, float head_length, float sld, float head_sld, float solvent_sld);
float Iq(float q, float tail_length, float head_length, float sld, float head_sld, float solvent_sld) {
  const float qsq = q * q;
  const float drh = head_sld - solvent_sld;
  const float drt = sld - solvent_sld;
  const float qT = q * tail_length;
  float Pq, inten;
  Pq = drh * (sin(q * (head_length + tail_length)) - sin(qT)) + drt * sin(qT);
  Pq *= Pq;
  Pq *= 4.0f / (qsq);

  inten = 2.0e-4f * 3.14159265358979323846f * Pq / qsq;

  inten /= 2.0f * (head_length + tail_length);

  return inten;
}

float Iqxy(float qx, float qy, float tail_length, float head_length, float sld, float head_sld, float solvent_sld);
float Iqxy(float qx, float qy, float tail_length, float head_length, float sld, float head_sld, float solvent_sld) {
  return Iq(sqrt(qx * qx + qy * qy), tail_length, head_length, sld, head_sld, solvent_sld);
}
kernel void lamellar_FFHG_Iq(global const float* q, global float* result, const int Nq,

                             global float* loops_g,

                             local float* loops, const float cutoff, const int Ntail_length, const int Nhead_length,

                             const float scale, const float background, const float sld, const float head_sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Ntail_length + Nhead_length) * 2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int tail_length_i = 0; tail_length_i < Ntail_length; tail_length_i++) {
      const float tail_length = loops[hook(4, 2 * (tail_length_i))];
      const float tail_length_w = loops[hook(4, 2 * (tail_length_i) + 1)];
      for (int head_length_i = 0; head_length_i < Nhead_length; head_length_i++) {
        const float head_length = loops[hook(4, 2 * (head_length_i + Ntail_length))];
        const float head_length_w = loops[hook(4, 2 * (head_length_i + Ntail_length) + 1)];

        const float weight = tail_length_w * head_length_w;
        if (weight > cutoff) {
          const float scattering = Iq(qi, tail_length, head_length, sld, head_sld, solvent_sld);

          if (!isnan(scattering)) {
            ret += weight * scattering;
            norm += weight;

            const float vol_weight = tail_length_w * head_length_w;
            vol += vol_weight * form_volume(tail_length, head_length);
            norm_vol += vol_weight;
          }
        }
      }
    }

    if (vol * norm_vol != 0.0f) {
      ret *= norm_vol / vol;
    }

    result[hook(1, i)] = scale * ret / norm + background;
  }
}