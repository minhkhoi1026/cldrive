//{"Gauss76Wt":14,"Gauss76Z":13,"Na_side":6,"Nb_side":7,"Nc_side":8,"Nq":2,"background":10,"cutoff":5,"loops":4,"loops_g":3,"q":0,"result":1,"scale":9,"sld":11,"solvent_sld":12}
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

float form_volume(float a_side, float b_side, float c_side);
float Iq(float q, float sld, float solvent_sld, float a_side, float b_side, float c_side);
float Iqxy(float qx, float qy, float sld, float solvent_sld, float a_side, float b_side, float c_side, float theta, float phi, float psi);

float _pkernel(float a, float b, float c, float ala, float alb, float alc);
float _pkernel(float a, float b, float c, float ala, float alb, float alc) {
  float argA, argB, argC, tmp1, tmp2, tmp3;

  argA = a * ala / 2.0f;
  argB = b * alb / 2.0f;
  argC = c * alc / 2.0f;
  if (argA == 0.0f) {
    tmp1 = 1.0f;
  } else {
    tmp1 = sin(argA) * sin(argA) / argA / argA;
  }
  if (argB == 0.0f) {
    tmp2 = 1.0f;
  } else {
    tmp2 = sin(argB) * sin(argB) / argB / argB;
  }
  if (argC == 0.0f) {
    tmp3 = 1.0f;
  } else {
    tmp3 = sin(argC) * sin(argC) / argC / argC;
  }
  return (tmp1 * tmp2 * tmp3);
}

float form_volume(float a_side, float b_side, float c_side) {
  return a_side * b_side * c_side;
}

float Iq(float q, float sld, float solvent_sld, float a_side, float b_side, float c_side) {
  float tmp1, tmp2, yyy;

  float mu = q * b_side;

  float a_scaled = a_side / b_side;
  float c_scaled = c_side / b_side;

  float summ = 0;

  for (int i = 0; i < 76; i++) {
    float summj = 0.0f;
    float sigma = 0.5f * (Gauss76Z[hook(13, i)] + 1.0f);

    for (int j = 0; j < 76; j++) {
      float uu = 0.5f * (Gauss76Z[hook(13, j)] + 1.0f);
      float mudum = mu * sqrt(1.0f - sigma * sigma);
      float arg1 = 0.5f * mudum * cos(0.5f * 3.14159265358979323846f * uu);
      float arg2 = 0.5f * mudum * a_scaled * sin(0.5f * 3.14159265358979323846f * uu);
      if (arg1 == 0.0f) {
        tmp1 = 1.0f;
      } else {
        tmp1 = sin(arg1) * sin(arg1) / arg1 / arg1;
      }
      if (arg2 == 0.0f) {
        tmp2 = 1.0f;
      } else {
        tmp2 = sin(arg2) * sin(arg2) / arg2 / arg2;
      }
      yyy = Gauss76Wt[hook(14, j)] * tmp1 * tmp2;

      summj += yyy;
    }

    float answer = 0.5f * summj;

    float arg = 0.5f * mu * c_scaled * sigma;
    if (arg == 0.0f) {
      answer *= 1.0f;
    } else {
      answer *= sin(arg) * sin(arg) / arg / arg;
    }

    yyy = Gauss76Wt[hook(14, i)] * answer;
    summ += yyy;
  }

  const float vd = (sld - solvent_sld) * form_volume(a_side, b_side, c_side);
  return 1.0e-4f * 0.5f * vd * vd * summ;
}

float Iqxy(float qx, float qy, float sld, float solvent_sld, float a_side, float b_side, float c_side, float theta, float phi, float psi) {
  float q = sqrt(qx * qx + qy * qy);
  float qx_scaled = qx / q;
  float qy_scaled = qy / q;

  theta *= 0.017453292519943295f;
  phi *= 0.017453292519943295f;
  psi *= 0.017453292519943295f;

  float cparallel_x = cos(theta) * cos(phi);
  float cparallel_y = sin(theta);

  float cos_val_c = cparallel_x * qx_scaled + cparallel_y * qy_scaled;

  float parallel_x = -cos(phi) * sin(psi) * sin(theta) + sin(phi) * cos(psi);
  float parallel_y = sin(psi) * cos(theta);
  float cos_val_a = parallel_x * qx_scaled + parallel_y * qy_scaled;

  float bparallel_x = -sin(theta) * cos(psi) * cos(phi) - sin(psi) * sin(phi);
  float bparallel_y = cos(theta) * cos(psi);
  float cos_val_b = bparallel_x * qx_scaled + bparallel_y * qy_scaled;

  if (fabs(cos_val_c) > 1.0f) {
    cos_val_c = 1.0f;
  }
  if (fabs(cos_val_a) > 1.0f) {
    cos_val_a = 1.0f;
  }
  if (fabs(cos_val_b) > 1.0f) {
    cos_val_b = 1.0f;
  }

  float form = _pkernel(q * a_side, q * b_side, q * c_side, cos_val_a, cos_val_b, cos_val_c);

  const float vd = (sld - solvent_sld) * form_volume(a_side, b_side, c_side);
  return 1.0e-4f * vd * vd * form;
}
kernel void parallelepiped_Iq(global const float* q, global float* result, const int Nq,

                              global float* loops_g,

                              local float* loops, const float cutoff, const int Na_side, const int Nb_side, const int Nc_side,

                              const float scale, const float background, const float sld, const float solvent_sld) {
  event_t e = async_work_group_copy(loops, loops_g, (Na_side + Nb_side + Nc_side) * 2, 0);
  wait_group_events(1, &e);

  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];

    float ret = 0.0f, norm = 0.0f;

    float vol = 0.0f, norm_vol = 0.0f;

    for (int a_side_i = 0; a_side_i < Na_side; a_side_i++) {
      const float a_side = loops[hook(4, 2 * (a_side_i))];
      const float a_side_w = loops[hook(4, 2 * (a_side_i) + 1)];
      for (int b_side_i = 0; b_side_i < Nb_side; b_side_i++) {
        const float b_side = loops[hook(4, 2 * (b_side_i + Na_side))];
        const float b_side_w = loops[hook(4, 2 * (b_side_i + Na_side) + 1)];
        for (int c_side_i = 0; c_side_i < Nc_side; c_side_i++) {
          const float c_side = loops[hook(4, 2 * (c_side_i + Na_side + Nb_side))];
          const float c_side_w = loops[hook(4, 2 * (c_side_i + Na_side + Nb_side) + 1)];

          const float weight = a_side_w * b_side_w * c_side_w;
          if (weight > cutoff) {
            const float scattering = Iq(qi, sld, solvent_sld, a_side, b_side, c_side);

            if (!isnan(scattering)) {
              ret += weight * scattering;
              norm += weight;

              const float vol_weight = a_side_w * b_side_w * c_side_w;
              vol += vol_weight * form_volume(a_side, b_side, c_side);
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