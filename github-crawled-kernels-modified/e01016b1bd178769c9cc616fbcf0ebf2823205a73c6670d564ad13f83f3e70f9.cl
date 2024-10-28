//{"Caille_parameter":12,"Nhead_length":7,"Nlayers":11,"Nq":2,"Nspacing":8,"Ntail_length":6,"background":10,"cutoff":5,"head_sld":14,"loops":4,"loops_g":3,"q":0,"result":1,"scale":9,"sld":13,"solvent_sld":15}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Iq(float qval, float tail_length, float head_length, float Nlayers, float dd, float Cp, float tail_sld, float head_sld, float solvent_sld);
float Iq(float qval, float tail_length, float head_length, float Nlayers, float dd, float Cp, float tail_sld, float head_sld, float solvent_sld) {
  float NN;
  float inten, Pq, Sq, alpha, temp, t2;

  int ii, NNint;

  const float Euler = 0.577215664901533f;

  NN = trunc(Nlayers);

  Pq = (head_sld - solvent_sld) * (sin(qval * (head_length + tail_length)) - sin(qval * tail_length)) + (tail_sld - solvent_sld) * sin(qval * tail_length);
  Pq *= Pq;
  Pq *= 4.0f / (qval * qval);

  NNint = (int)NN;
  ii = 0;
  Sq = 0.0f;
  for (ii = 1; ii <= (NNint - 1); ii += 1) {
    temp = 0.0f;
    alpha = Cp / 4.0f / 3.14159265358979323846f / 3.14159265358979323846f * (log(3.14159265358979323846f * ii) + Euler);

    t2 = 2.0f * qval * qval * dd * dd * alpha;

    temp = 1.0f - ii / NN;

    temp *= cos(dd * qval * ii);

    temp *= exp(-t2 / 2.0f);

    Sq += temp;
  }

  Sq *= 2.0f;
  Sq += 1.0f;

  inten = 2.0f * 3.14159265358979323846f * Pq * Sq / (dd * qval * qval);

  inten *= 1.0e-04f;
  return (inten);
}

float form_volume(float tail_length, float head_length, float spacing);
float form_volume(float tail_length, float head_length, float spacing) {
  return 1.0f;
}

float Iqxy(float qx, float qy, float tail_length, float head_length, float Nlayers, float spacing, float Caille_parameter, float sld, float head_sld, float solvent_sld);
float Iqxy(float qx, float qy, float tail_length, float head_length, float Nlayers, float spacing, float Caille_parameter, float sld, float head_sld, float solvent_sld) {
  return Iq(sqrt(qx * qx + qy * qy), tail_length, head_length, Nlayers, spacing, Caille_parameter, sld, head_sld, solvent_sld);
}
kernel void lamellarCailleHG_Iq(global const float* q, global float* result, const int Nq,

                                global float* loops_g,

                                local float* loops, const float cutoff, const int Ntail_length, const int Nhead_length, const int Nspacing,

                                const float scale, const float background, const float Nlayers, const float Caille_parameter, const float sld, const float head_sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Ntail_length + Nhead_length + Nspacing) * 2, 0);
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
        for (int spacing_i = 0; spacing_i < Nspacing; spacing_i++) {
          const float spacing = loops[hook(4, 2 * (spacing_i + Ntail_length + Nhead_length))];
          const float spacing_w = loops[hook(4, 2 * (spacing_i + Ntail_length + Nhead_length) + 1)];

          const float weight = tail_length_w * head_length_w * spacing_w;
          if (weight > cutoff) {
            const float scattering = Iq(qi, tail_length, head_length, Nlayers, spacing, Caille_parameter, sld, head_sld, solvent_sld);

            if (!isnan(scattering)) {
              ret += weight * scattering;
              norm += weight;

              const float vol_weight = tail_length_w * head_length_w * spacing_w;
              vol += vol_weight * form_volume(tail_length, head_length, spacing);
              norm_vol += vol_weight;
            }
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