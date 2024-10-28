//{"Nq":3,"Nthickness":7,"background":9,"cutoff":6,"loops":5,"loops_g":4,"qx":0,"qy":1,"result":2,"scale":8,"sld":10,"solvent_sld":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float form_volume(float thickness);
float form_volume(float thickness) {
  return 1.0f;
}

float Iq(float q, float sld, float solvent_sld, float thickness);
float Iq(float q, float sld, float solvent_sld, float thickness) {
  const float sub = sld - solvent_sld;
  const float qsq = q * q;

  const float sinq2 = sin(0.5f * q * thickness);
  return 4.0e-4f * 3.14159265358979323846f * sub * sub / qsq * 2.0f * sinq2 * sinq2 / (thickness * qsq);
}

float Iqxy(float qx, float qy, float sld, float solvent_sld, float thickness);
float Iqxy(float qx, float qy, float sld, float solvent_sld, float thickness) {
  return Iq(sqrt(qx * qx + qy * qy), sld, solvent_sld, thickness);
}
kernel void lamellar_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq,

                          global float* loops_g,

                          local float* loops, const float cutoff, const int Nthickness,

                          const float scale, const float background, const float sld, const float solvent_sld) {
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
        const float scattering = Iqxy(qxi, qyi, sld, solvent_sld, thickness);
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