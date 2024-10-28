//{"Nlayers":10,"Nq":3,"Nthickness":7,"background":9,"cutoff":6,"loops":5,"loops_g":4,"qx":0,"qy":1,"result":2,"scale":8,"sld":13,"solvent_sld":14,"spacing":11,"spacing_polydisp":12}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Iq(float qval, float th, float Nlayers, float davg, float pd, float sld, float solvent_sld);
float paraCryst_sn(float ww, float qval, float davg, long Nlayers, float an);
float paraCryst_an(float ww, float qval, float davg, long Nlayers);
float Iq(float qval, float th, float Nlayers, float davg, float pd, float sld, float solvent_sld) {
  float inten, contr, xn;
  float xi, ww, Pbil, Znq, Snq, an;
  long n1, n2;

  contr = sld - solvent_sld;

  n1 = (long)trunc(Nlayers);
  n2 = n1 + 1;
  xn = (float)n2 - Nlayers;

  ww = exp(-qval * qval * pd * pd * davg * davg / 2.0f);

  an = paraCryst_an(ww, qval, davg, n1);
  Snq = paraCryst_sn(ww, qval, davg, n1, an);

  Znq = xn * Snq;

  an = paraCryst_an(ww, qval, davg, n2);
  Snq = paraCryst_sn(ww, qval, davg, n2, an);

  Znq += (1.0f - xn) * Snq;

  Znq += (1.0f - ww * ww) / (1.0f + ww * ww - 2.0f * ww * cos(qval * davg));

  xi = th / 2.0f;
  Pbil = (sin(qval * xi) / (qval * xi)) * (sin(qval * xi) / (qval * xi));

  inten = 2.0f * 3.14159265358979323846f * contr * contr * Pbil * Znq / (qval * qval);
  inten *= 1.0e-04f;

  return (inten);
}

float paraCryst_sn(float ww, float qval, float davg, long Nlayers, float an) {
  float Snq;

  Snq = an / ((float)Nlayers * pow((1.0f + ww * ww - 2.0f * ww * cos(qval * davg)), 2));

  return (Snq);
}

float paraCryst_an(float ww, float qval, float davg, long Nlayers) {
  float an;

  an = 4.0f * ww * ww - 2.0f * (ww * ww * ww + ww) * cos(qval * davg);
  an -= 4.0f * pow(ww, (Nlayers + 2)) * cos((float)Nlayers * qval * davg);
  an += 2.0f * pow(ww, (Nlayers + 3)) * cos((float)(Nlayers - 1) * qval * davg);
  an += 2.0f * pow(ww, (Nlayers + 1)) * cos((float)(Nlayers + 1) * qval * davg);

  return (an);
}

float form_volume(float thickness);
float form_volume(float thickness) {
  return 1.0f;
}

float Iqxy(float qx, float qy, float thickness, float Nlayers, float spacing, float spacing_polydisp, float sld, float solvent_sld);
float Iqxy(float qx, float qy, float thickness, float Nlayers, float spacing, float spacing_polydisp, float sld, float solvent_sld) {
  return Iq(sqrt(qx * qx + qy * qy), thickness, Nlayers, spacing, spacing_polydisp, sld, solvent_sld);
}
kernel void lamellarPC_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq,

                            global float* loops_g,

                            local float* loops, const float cutoff, const int Nthickness,

                            const float scale, const float background, const float Nlayers, const float spacing, const float spacing_polydisp, const float sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Nthickness)*2, 0);
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

      const float weight = thickness_w;
      if (weight > cutoff) {
        const float scattering = Iqxy(qxi, qyi, thickness, Nlayers, spacing, spacing_polydisp, sld, solvent_sld);
        if (!isnan(scattering)) {
          const float next = weight * scattering;

          ret += next;

          norm += weight;

          const float vol_weight = thickness_w;
          vol += vol_weight * form_volume(thickness);

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