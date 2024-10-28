//{"fe":8,"fn":2,"jsr":0,"ke":6,"kn":1,"offset":5,"value":4,"we":7,"wn":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float r4_uni(global unsigned int* jsr) {
  unsigned int jsr_input;
  float value;

  jsr_input = *jsr;

  *jsr = (*jsr ^ (*jsr << 13));
  *jsr = (*jsr ^ (*jsr >> 17));
  *jsr = (*jsr ^ (*jsr << 5));

  value = fmod(0.5 + (float)(jsr_input + *jsr) / 65536.0 / 65536.0, 1.0);

  return value;
}

unsigned int shr3_seeded(global unsigned int* jsr) {
  unsigned int value;

  value = *jsr;

  *jsr = (*jsr ^ (*jsr << 13));
  *jsr = (*jsr ^ (*jsr >> 17));
  *jsr = (*jsr ^ (*jsr << 5));

  value = value + *jsr;

  return value;
}

float r4_exp(global unsigned int* jsr, global unsigned int* ke, global float* fe, global float* we) {
  unsigned int iz;
  unsigned int jz;
  float value;
  float x;

  jz = shr3_seeded(jsr);
  iz = (jz & 255);

  if (jz < ke[hook(6, iz)]) {
    value = (float)(jz)*we[hook(7, iz)];
  } else {
    for (;;) {
      if (iz == 0) {
        value = 7.69711 - log(r4_uni(jsr));
        break;
      }

      x = (float)(jz)*we[hook(7, iz)];

      if (fe[hook(8, iz)] + r4_uni(jsr) * (fe[hook(8, iz - 1)] - fe[hook(8, iz)]) < exp(-x)) {
        value = x;
        break;
      }

      jz = shr3_seeded(jsr);
      iz = (jz & 255);

      if (jz < ke[hook(6, iz)]) {
        value = (float)(jz)*we[hook(7, iz)];
        break;
      }
    }
  }
  return value;
}

void r4_exp_setup(global unsigned int* ke, global float* fe, global float* we) {
  float de = 7.697117470131487;
  int i;
  const float m2 = 2147483648.0;
  float q;
  float te = 7.697117470131487;
  const float ve = 3.949659822581572E-03;

  q = ve / exp(-de);

  ke[hook(6, 0)] = (unsigned int)((de / q) * m2);
  ke[hook(6, 1)] = 0;

  we[hook(7, 0)] = (float)(q / m2);
  we[hook(7, 255)] = (float)(de / m2);

  fe[hook(8, 0)] = 1.0;
  fe[hook(8, 255)] = (float)(exp(-de));

  for (i = 254; 1 <= i; i--) {
    de = -log(ve / de + exp(-de));
    ke[hook(6, i + 1)] = (unsigned int)((de / te) * m2);
    te = de;
    fe[hook(8, i)] = (float)(exp(-de));
    we[hook(7, i)] = (float)(de / m2);
  }
  return;
}

kernel void r4_nor(global unsigned int* jsr, global unsigned int* kn, global float* fn, global float* wn, global float* value, unsigned int offset) {
  if (get_global_id(0) == 0) {
    int hz;
    unsigned int iz;
    const float r = 3.442620;
    float x;
    float y;

    hz = (int)shr3_seeded(jsr);
    iz = (hz & 127);

    if (abs(hz) < kn[hook(1, iz)]) {
      value[hook(4, offset)] = (float)(hz)*wn[hook(3, iz)];
    } else {
      for (;;) {
        if (iz == 0) {
          for (;;) {
            x = -0.2904764 * log(r4_uni(jsr));
            y = -log(r4_uni(jsr));
            if (x * x <= y + y) {
              break;
            }
          }

          if (hz <= 0) {
            value[hook(4, offset)] = -r - x;
          } else {
            value[hook(4, offset)] = +r + x;
          }
          break;
        }

        x = (float)(hz)*wn[hook(3, iz)];

        if (fn[hook(2, iz)] + r4_uni(jsr) * (fn[hook(2, iz - 1)] - fn[hook(2, iz)]) < exp(-0.5 * x * x)) {
          value[hook(4, offset)] = x;
          break;
        }

        hz = (int)shr3_seeded(jsr);
        iz = (hz & 127);

        if (abs(hz) < kn[hook(1, iz)]) {
          value[hook(4, offset)] = (float)(hz)*wn[hook(3, iz)];
          break;
        }
      }
    }
  }
}