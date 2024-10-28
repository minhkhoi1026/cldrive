//{"Caille_parameter":12,"Nlayers":11,"Nq":3,"Nspacing":8,"Nthickness":7,"background":10,"cutoff":6,"loops":5,"loops_g":4,"qx":0,"qy":1,"result":2,"scale":9,"sld":13,"solvent_sld":14}
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
kernel void lamellarPS_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq,

                            global float* loops_g,

                            local float* loops, const float cutoff, const int Nthickness, const int Nspacing,

                            const float scale, const float background, const float Nlayers, const float Caille_parameter, const float sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Nthickness + Nspacing) * 2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int thickness_i = 0; thickness_i < Nthickness; thickness_i++) {
      const float thickness = loops[hook(5, 2 * (thickness_i))];
      const float thickness_w = loops[hook(5, 2 * (thickness_i) + 1)];
      for (int spacing_i = 0; spacing_i < Nspacing; spacing_i++) {
        const float spacing = loops[hook(5, 2 * (spacing_i + Nthickness))];
        const float spacing_w = loops[hook(5, 2 * (spacing_i + Nthickness) + 1)];

        const float weight = thickness_w * spacing_w;
        if (weight > cutoff) {
          const float scattering = Iqxy(qxi, qyi, thickness, Nlayers, spacing, Caille_parameter, sld, solvent_sld);
          if (!isnan(scattering)) {
            const float next = weight * scattering;

            ret += next;

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

    result[hook(2, i)] = scale * ret / norm + background;
  }
}