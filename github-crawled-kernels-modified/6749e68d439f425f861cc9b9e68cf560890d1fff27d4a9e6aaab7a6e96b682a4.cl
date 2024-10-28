//{"Nhead_length":8,"Nq":3,"Ntail_length":7,"background":10,"cutoff":6,"head_sld":12,"loops":5,"loops_g":4,"qx":0,"qy":1,"result":2,"scale":9,"sld":11,"solvent_sld":13}
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
kernel void lamellar_FFHG_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq,

                               global float* loops_g,

                               local float* loops, const float cutoff, const int Ntail_length, const int Nhead_length,

                               const float scale, const float background, const float sld, const float head_sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Ntail_length + Nhead_length) * 2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int tail_length_i = 0; tail_length_i < Ntail_length; tail_length_i++) {
      const float tail_length = loops[hook(5, 2 * (tail_length_i))];
      const float tail_length_w = loops[hook(5, 2 * (tail_length_i) + 1)];
      for (int head_length_i = 0; head_length_i < Nhead_length; head_length_i++) {
        const float head_length = loops[hook(5, 2 * (head_length_i + Ntail_length))];
        const float head_length_w = loops[hook(5, 2 * (head_length_i + Ntail_length) + 1)];

        const float weight = tail_length_w * head_length_w;
        if (weight > cutoff) {
          const float scattering = Iqxy(qxi, qyi, tail_length, head_length, sld, head_sld, solvent_sld);
          if (!isnan(scattering)) {
            const float next = weight * scattering;

            ret += next;

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

    result[hook(2, i)] = scale * ret / norm + background;
  }
}