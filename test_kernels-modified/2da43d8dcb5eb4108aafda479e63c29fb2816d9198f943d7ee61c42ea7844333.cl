//{"Caille_parameter":11,"Nlayers":10,"Nq":2,"Nspacing":7,"Nthickness":6,"background":9,"cutoff":5,"loops":4,"loops_g":3,"q":0,"result":1,"scale":8,"sld":12,"solvent_sld":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Iq(float qval, float del, float Nlayers, float dd, float Cp, float sld, float solvent_sld);
float Iq(float qval, float del, float Nlayers, float dd, float Cp, float sld, float solvent_sld) {
  float contr, NN;
  float inten, Pq, Sq, alpha, temp, t2;

  int ii, NNint;

  const float Euler = 0.577215664901533f;

  NN = trunc(Nlayers);

  contr = sld - solvent_sld;

  Pq = 2.0f * contr * contr / qval / qval * (1.0f - cos(qval * del));

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

float form_volume(float thickness, float spacing);
float form_volume(float thickness, float spacing) {
  return 1.0f;
}

float Iqxy(float qx, float qy, float thickness, float Nlayers, float spacing, float Caille_parameter, float sld, float solvent_sld);
float Iqxy(float qx, float qy, float thickness, float Nlayers, float spacing, float Caille_parameter, float sld, float solvent_sld) {
  return Iq(sqrt(qx * qx + qy * qy), thickness, Nlayers, spacing, Caille_parameter, sld, solvent_sld);
}
kernel void lamellarPS_Iq(global const float* q, global float* result, const int Nq,

                          global float* loops_g,

                          local float* loops, const float cutoff, const int Nthickness, const int Nspacing,

                          const float scale, const float background, const float Nlayers, const float Caille_parameter, const float sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Nthickness + Nspacing) * 2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int thickness_i = 0; thickness_i < Nthickness; thickness_i++) {
      const float thickness = loops[hook(4, 2 * (thickness_i))];
      const float thickness_w = loops[hook(4, 2 * (thickness_i) + 1)];
      for (int spacing_i = 0; spacing_i < Nspacing; spacing_i++) {
        const float spacing = loops[hook(4, 2 * (spacing_i + Nthickness))];
        const float spacing_w = loops[hook(4, 2 * (spacing_i + Nthickness) + 1)];

        const float weight = thickness_w * spacing_w;
        if (weight > cutoff) {
          const float scattering = Iq(qi, thickness, Nlayers, spacing, Caille_parameter, sld, solvent_sld);

          if (!isnan(scattering)) {
            ret += weight * scattering;
            norm += weight;

            const float vol_weight = thickness_w * spacing_w;
            vol += vol_weight * form_volume(thickness, spacing);
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