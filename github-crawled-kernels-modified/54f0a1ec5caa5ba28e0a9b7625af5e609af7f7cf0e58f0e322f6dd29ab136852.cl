//{"Nedge_separation":7,"Nnumber_of_pearls":9,"Nq":2,"Nradius":6,"Nstring_thickness":8,"background":11,"cutoff":5,"loops":4,"loops_g":3,"q":0,"result":1,"scale":10,"sld":12,"solvent_sld":14,"string_sld":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Si(float x);
float Si(float x) {
  float out;
  float pi = 4.0f * atan(1.0f);

  if (x >= pi * 6.2f / 4.0f) {
    float out_sin = 0.0f;
    float out_cos = 0.0f;
    out = pi / 2.0f;

    out_cos = 1 / x - 2 / pow(x, 3) + 24 / pow(x, 5) - 720 / pow(x, 7) + 40320 / pow(x, 9);
    out_sin = 1 / x - 6 / pow(x, 4) + 120 / pow(x, 6) - 5040 / pow(x, 8) + 362880 / pow(x, 10);

    out -= cos(x) * out_cos;
    out -= sin(x) * out_sin;
    return out;
  }

  out = x - pow(x, 3) / 18 + pow(x, 5) / 600 - pow(x, 7) / 35280 + pow(x, 9) / 3265920;

  return out;
}

float _pearl_necklace_kernel(float q, float radius, float edge_separation, float thick_string, float num_pearls, float sld_pearl, float sld_string, float sld_solv);
float form_volume(float radius, float edge_separation, float string_thickness, float number_of_pearls);
float sinc(float x);

float Iq(float q, float radius, float edge_separation, float string_thickness, float number_of_pearls, float sld, float string_sld, float solvent_sld);
float Iqxy(float qx, float qy, float radius, float edge_separation, float string_thickness, float number_of_pearls, float sld, float string_sld, float solvent_sld);

float ER(float radius, float edge_separation, float string_thickness, float number_of_pearls);
float VR(float radius, float edge_separation, float string_thickness, float number_of_pearls);

float _pearl_necklace_kernel(float q, float radius, float edge_separation, float thick_string, float num_pearls, float sld_pearl, float sld_string, float sld_solv) {
  float contrast_pearl = sld_pearl - sld_solv;
  float contrast_string = sld_string - sld_solv;

  float pi = 4.0f * atan(1.0f);
  float tot_vol = form_volume(radius, edge_separation, thick_string, num_pearls);
  float string_vol = edge_separation * pi * pow((thick_string / 2.0f), 2);
  float pearl_vol = 4.0f / 3.0f * pi * pow(radius, 3);
  float num_strings = num_pearls - 1;

  float m_r = contrast_string * string_vol;
  float m_s = contrast_pearl * pearl_vol;
  float psi, gamma, beta;

  float sss;
  float srr;
  float srs;
  float A_s, srr_1, srr_2, srr_3;
  float form_factor;

  psi = sin(q * radius);
  psi -= q * radius * cos(q * radius);
  psi /= pow((q * radius), 3);
  psi *= 3.0f;

  gamma = Si(q * edge_separation);
  gamma /= (q * edge_separation);
  beta = Si(q * (edge_separation + radius));
  beta -= Si(q * radius);
  beta /= (q * edge_separation);

  A_s = edge_separation + 2.0f * radius;

  sss = 1.0f - pow(sinc(q * A_s), num_pearls);
  sss /= pow((1.0f - sinc(q * A_s)), 2);
  sss *= -sinc(q * A_s);
  sss -= num_pearls / 2.0f;
  sss += num_pearls / (1.0f - sinc(q * A_s));
  sss *= 2.0f * pow((m_s * psi), 2);

  srr_1 = -pow(sinc(q * edge_separation / 2.0f), 2);

  srr_1 += 2.0f * gamma;
  srr_1 *= num_strings;
  srr_2 = 2.0f / (1.0f - sinc(q * A_s));
  srr_2 *= num_strings * pow(beta, 2);
  srr_3 = 1.0f - pow(sinc(q * A_s), num_strings);
  srr_3 /= pow((1.0f - sinc(q * A_s)), 2);
  srr_3 *= -2.0f * pow(beta, 2);

  srr = srr_1 + srr_2 + srr_3;
  srr *= pow(m_r, 2);

  srs = 1.0f;
  srs -= pow(sinc(q * A_s), num_strings);
  srs /= pow((1.0f - sinc(q * A_s)), 2);
  srs *= -sinc(q * A_s);
  srs += (num_strings / (1.0f - sinc(q * A_s)));
  srs *= 4.0f * (m_r * m_s * beta * psi);

  form_factor = sss + srr + srs;
  form_factor /= (tot_vol * 1.0e4f);

  return (form_factor);
}

float form_volume(float radius, float edge_separation, float string_thickness, float number_of_pearls) {
  float total_vol;

  float pi = 4.0f * atan(1.0f);
  float number_of_strings = number_of_pearls - 1.0f;

  float string_vol = edge_separation * pi * pow((string_thickness / 2.0f), 2);
  float pearl_vol = 4.0f / 3.0f * pi * pow(radius, 3);

  total_vol = number_of_strings * string_vol;
  total_vol += number_of_pearls * pearl_vol;

  return (total_vol);
}

float sinc(float x) {
  float num = sin(x);
  float denom = x;
  return num / denom;
}

float Iq(float q, float radius, float edge_separation, float string_thickness, float number_of_pearls, float sld, float string_sld, float solvent_sld) {
  float value = 0.0f;
  float tot_vol = 0.0f;

  value = _pearl_necklace_kernel(q, radius, edge_separation, string_thickness, number_of_pearls, sld, string_sld, solvent_sld);
  tot_vol = form_volume(radius, edge_separation, string_thickness, number_of_pearls);

  return value * tot_vol;
}

float Iqxy(float qx, float qy, float radius, float edge_separation, float string_thickness, float number_of_pearls, float sld, float string_sld, float solvent_sld) {
  float q = sqrt(qx * qx + qy * qy);
  return (Iq(q, radius, edge_separation, string_thickness, number_of_pearls, sld, string_sld, solvent_sld));
}

float ER(float radius, float edge_separation, float string_thickness, float number_of_pearls) {
  float tot_vol = form_volume(radius, edge_separation, string_thickness, number_of_pearls);
  float pi = 4.0f * atan(1.0f);

  float rad_out = pow((3.0f * tot_vol / 4.0f / pi), 0.33333f);

  return rad_out;
}
float VR(float radius, float edge_separation, float string_thickness, float number_of_pearls) {
  return 1.0f;
}
kernel void pearl_necklace_Iq(global const float* q, global float* result, const int Nq,

                              global float* loops_g,

                              local float* loops, const float cutoff, const int Nradius, const int Nedge_separation, const int Nstring_thickness, const int Nnumber_of_pearls,

                              const float scale, const float background, const float sld, const float string_sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Nradius + Nedge_separation + Nstring_thickness + Nnumber_of_pearls) * 2, 0);
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
      for (int edge_separation_i = 0; edge_separation_i < Nedge_separation; edge_separation_i++) {
        const float edge_separation = loops[hook(4, 2 * (edge_separation_i + Nradius))];
        const float edge_separation_w = loops[hook(4, 2 * (edge_separation_i + Nradius) + 1)];
        for (int string_thickness_i = 0; string_thickness_i < Nstring_thickness; string_thickness_i++) {
          const float string_thickness = loops[hook(4, 2 * (string_thickness_i + Nradius + Nedge_separation))];
          const float string_thickness_w = loops[hook(4, 2 * (string_thickness_i + Nradius + Nedge_separation) + 1)];
          for (int number_of_pearls_i = 0; number_of_pearls_i < Nnumber_of_pearls; number_of_pearls_i++) {
            const float number_of_pearls = loops[hook(4, 2 * (number_of_pearls_i + Nradius + Nedge_separation + Nstring_thickness))];
            const float number_of_pearls_w = loops[hook(4, 2 * (number_of_pearls_i + Nradius + Nedge_separation + Nstring_thickness) + 1)];

            const float weight = radius_w * edge_separation_w * string_thickness_w * number_of_pearls_w;
            if (weight > cutoff) {
              const float scattering = Iq(qi, radius, edge_separation, string_thickness, number_of_pearls, sld, string_sld, solvent_sld);

              if (!isnan(scattering)) {
                ret += weight * scattering;
                norm += weight;

                const float vol_weight = radius_w * edge_separation_w * string_thickness_w * number_of_pearls_w;
                vol += vol_weight * form_volume(radius, edge_separation, string_thickness, number_of_pearls);
                norm_vol += vol_weight;
              }
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