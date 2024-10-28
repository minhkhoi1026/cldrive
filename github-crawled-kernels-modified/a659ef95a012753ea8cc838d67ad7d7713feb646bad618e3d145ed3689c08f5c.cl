//{"Gauss76Wt":15,"Gauss76Z":14,"Nlength":8,"Nq":2,"Nradius":6,"Nthickness":7,"background":10,"core_sld":11,"cutoff":5,"loops":4,"loops_g":3,"q":0,"result":1,"scale":9,"shell_sld":12,"solvent_sld":13}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float J1(float x);
float J1(float x) {
  const float ax = fabs(x);
  if (ax < 8.0f) {
    const float y = x * x;
    const float ans1 = x * (72362614232.0f + y * (-7895059235.0f + y * (242396853.1f + y * (-2972611.439f + y * (15704.48260f + y * (-30.16036606f))))));
    const float ans2 = 144725228442.0f + y * (2300535178.0f + y * (18583304.74f + y * (99447.43394f + y * (376.9991397f + y))));
    return ans1 / ans2;
  } else {
    const float y = 64.0f / (ax * ax);
    const float xx = ax - 2.356194491f;
    const float ans1 = 1.0f + y * (0.183105e-2f + y * (-0.3516396496e-4f + y * (0.2457520174e-5f + y * -0.240337019e-6f)));
    const float ans2 = 0.04687499995f + y * (-0.2002690873e-3f + y * (0.8449199096e-5f + y * (-0.88228987e-6f + y * 0.105787412e-6f)));
    float sn, cn;
    do {
      const float _t_ = xx;
      sn = sin(_t_);
      cn = cos(_t_);
    } while (0);
    const float ans = sqrt(0.636619772f / ax) * (cn * ans1 - (8.0f / ax) * sn * ans2);
    return (x < 0.0f) ? -ans : ans;
  }
}
constant float Gauss76Wt[76] = {.00126779163408536f, .00294910295364247f, .00462793522803742f, .00629918049732845f, .00795984747723973f, .00960710541471375f, .0112381685696677f, .0128502838475101f, .0144407317482767f, .0160068299122486f, .0175459372914742f, .0190554584671906f, .020532847967908f, .0219756145344162f, .0233813253070112f, .0247476099206597f, .026072164497986f, .0273527555318275f, .028587223650054f, .029773487255905f, .0309095460374916f, .0319934843404216f, .0330234743977917f, .0339977794120564f, .0349147564835508f, .0357728593807139f, .0365706411473296f, .0373067565423816f, .0379799643084053f, .0385891292645067f, .0391332242205184f, .0396113317090621f, .0400226455325968f, .040366472122844f, .0406422317102947f, .0408494593018285f, .040987805464794f, .0410570369162294f, .0410570369162294f, .040987805464794f, .0408494593018285f, .0406422317102947f, .040366472122844f, .0400226455325968f, .0396113317090621f, .0391332242205184f, .0385891292645067f, .0379799643084053f, .0373067565423816f, .0365706411473296f, .0357728593807139f, .0349147564835508f, .0339977794120564f, .0330234743977917f, .0319934843404216f, .0309095460374916f, .029773487255905f, .028587223650054f, .0273527555318275f, .026072164497986f, .0247476099206597f, .0233813253070112f, .0219756145344162f, .020532847967908f, .0190554584671906f, .0175459372914742f, .0160068299122486f, .0144407317482767f, .0128502838475101f, .0112381685696677f, .00960710541471375f, .00795984747723973f, .00629918049732845f, .00462793522803742f, .00294910295364247f, .00126779163408536f};

constant float Gauss76Z[76] = {-.999505948362153f, -.997397786355355f, -.993608772723527f, -.988144453359837f, -.981013938975656f, -.972229228520377f, -.961805126758768f, -.949759207710896f, -.936111781934811f, -.92088586125215f, -.904107119545567f, -.885803849292083f, -.866006913771982f, -.844749694983342f, -.822068037328975f, -.7980001871612f, -.77258672828181f, -.74587051350361f, -.717896592387704f, -.688712135277641f, -.658366353758143f, -.626910417672267f, -.594397368836793f, -.560882031601237f, -.526420920401243f, -.491072144462194f, -.454895309813726f, -.417951418780327f, -.380302767117504f, -.342012838966962f, -.303146199807908f, -.263768387584994f, -.223945802196474f, -.183745593528914f, -.143235548227268f, -.102483975391227f, -.0615595913906112f, -.0205314039939986f, .0205314039939986f, .0615595913906112f, .102483975391227f, .143235548227268f, .183745593528914f, .223945802196474f, .263768387584994f, .303146199807908f, .342012838966962f, .380302767117504f, .417951418780327f, .454895309813726f, .491072144462194f, .526420920401243f, .560882031601237f, .594397368836793f, .626910417672267f, .658366353758143f, .688712135277641f, .717896592387704f, .74587051350361f, .77258672828181f, .7980001871612f, .822068037328975f, .844749694983342f, .866006913771982f, .885803849292083f, .904107119545567f, .92088586125215f, .936111781934811f, .949759207710896f, .961805126758768f, .972229228520377f, .981013938975656f, .988144453359837f, .993608772723527f, .997397786355355f, .999505948362153f};

float form_volume(float radius, float thickness, float length);
float Iq(float q, float core_sld, float shell_sld, float solvent_sld, float radius, float thickness, float length);
float Iqxy(float qx, float qy, float core_sld, float shell_sld, float solvent_sld, float radius, float thickness, float length, float theta, float phi);

float _cyl(float twovd, float besarg, float siarg);
float _cyl(float twovd, float besarg, float siarg) {
  const float bj = (besarg == 0.0f ? 0.5f : J1(besarg) / besarg);
  const float si = (siarg == 0.0f ? 1.0f : sin(siarg) / siarg);
  return twovd * si * bj;
}

float form_volume(float radius, float thickness, float length) {
  return 3.14159265358979323846f * (radius + thickness) * (radius + thickness) * (length + 2 * thickness);
}

float Iq(float q, float core_sld, float shell_sld, float solvent_sld, float radius, float thickness, float length) {
  const float core_qr = q * radius;
  const float core_qh = q * 0.5f * length;
  const float core_twovd = 2.0f * form_volume(radius, 0, length) * (core_sld - shell_sld);
  const float shell_qr = q * (radius + thickness);
  const float shell_qh = q * (0.5f * length + thickness);
  const float shell_twovd = 2.0f * form_volume(radius, thickness, length) * (shell_sld - solvent_sld);
  float total = 0.0f;

  for (int i = 0; i < 76; i++) {
    float sn, cn;
    const float alpha = 0.5f * (Gauss76Z[hook(14, i)] * 0x1.921fb54442d18p+0 + 0x1.921fb54442d18p+0);
    do {
      const float _t_ = alpha;
      sn = sin(_t_);
      cn = cos(_t_);
    } while (0);
    const float fq = _cyl(core_twovd, core_qr * sn, core_qh * cn) + _cyl(shell_twovd, shell_qr * sn, shell_qh * cn);
    total += Gauss76Wt[hook(15, i)] * fq * fq * sn;
  }

  return 1.0e-4f * total * 0x1.921fb54442d18p-1;
}

float Iqxy(float qx, float qy, float core_sld, float shell_sld, float solvent_sld, float radius, float thickness, float length, float theta, float phi) {
  float sn, cn;

  do {
    const float _t_ = theta * 0.017453292519943295f;
    sn = sin(_t_);
    cn = cos(_t_);
  } while (0);

  const float q = sqrt(qx * qx + qy * qy);
  const float cos_val = cn * cos(phi * 0.017453292519943295f) * (qx / q) + sn * (qy / q);
  const float alpha = acos(cos_val);

  const float core_qr = q * radius;
  const float core_qh = q * 0.5f * length;
  const float core_twovd = 2.0f * form_volume(radius, 0, length) * (core_sld - shell_sld);
  const float shell_qr = q * (radius + thickness);
  const float shell_qh = q * (0.5f * length + thickness);
  const float shell_twovd = 2.0f * form_volume(radius, thickness, length) * (shell_sld - solvent_sld);

  do {
    const float _t_ = alpha;
    sn = sin(_t_);
    cn = cos(_t_);
  } while (0);
  const float fq = _cyl(core_twovd, core_qr * sn, core_qh * cn) + _cyl(shell_twovd, shell_qr * sn, shell_qh * cn);
  return 1.0e-4f * fq * fq;
}
kernel void core_shell_cylinder_Iq(global const float* q, global float* result, const int Nq,

                                   global float* loops_g,

                                   local float* loops, const float cutoff, const int Nradius, const int Nthickness, const int Nlength,

                                   const float scale, const float background, const float core_sld, const float shell_sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Nradius + Nthickness + Nlength) * 2, 0);
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
      for (int thickness_i = 0; thickness_i < Nthickness; thickness_i++) {
        const float thickness = loops[hook(4, 2 * (thickness_i + Nradius))];
        const float thickness_w = loops[hook(4, 2 * (thickness_i + Nradius) + 1)];
        for (int length_i = 0; length_i < Nlength; length_i++) {
          const float length = loops[hook(4, 2 * (length_i + Nradius + Nthickness))];
          const float length_w = loops[hook(4, 2 * (length_i + Nradius + Nthickness) + 1)];

          const float weight = radius_w * thickness_w * length_w;
          if (weight > cutoff) {
            const float scattering = Iq(qi, core_sld, shell_sld, solvent_sld, radius, thickness, length);

            if (!isnan(scattering)) {
              ret += weight * scattering;
              norm += weight;

              const float vol_weight = radius_w * thickness_w * length_w;
              vol += vol_weight * form_volume(radius, thickness, length);
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