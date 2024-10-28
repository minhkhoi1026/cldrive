//{"fe":5,"fn":1,"ke":3,"kn":0,"we":4,"wn":2}
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

  if (jz < ke[hook(3, iz)]) {
    value = (float)(jz)*we[hook(4, iz)];
  } else {
    for (;;) {
      if (iz == 0) {
        value = 7.69711 - log(r4_uni(jsr));
        break;
      }

      x = (float)(jz)*we[hook(4, iz)];

      if (fe[hook(5, iz)] + r4_uni(jsr) * (fe[hook(5, iz - 1)] - fe[hook(5, iz)]) < exp(-x)) {
        value = x;
        break;
      }

      jz = shr3_seeded(jsr);
      iz = (jz & 255);

      if (jz < ke[hook(3, iz)]) {
        value = (float)(jz)*we[hook(4, iz)];
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

  ke[hook(3, 0)] = (unsigned int)((de / q) * m2);
  ke[hook(3, 1)] = 0;

  we[hook(4, 0)] = (float)(q / m2);
  we[hook(4, 255)] = (float)(de / m2);

  fe[hook(5, 0)] = 1.0;
  fe[hook(5, 255)] = (float)(exp(-de));

  for (i = 254; 1 <= i; i--) {
    de = -log(ve / de + exp(-de));
    ke[hook(3, i + 1)] = (unsigned int)((de / te) * m2);
    te = de;
    fe[hook(5, i)] = (float)(exp(-de));
    we[hook(4, i)] = (float)(de / m2);
  }
  return;
}

kernel void r4_nor_setup(global unsigned int* kn, global float* fn, global float* wn) {
  float dn = 3.442619855899;
  int i;
  const float m1 = 2147483648.0;
  float q;
  float tn = 3.442619855899;
  const float vn = 9.91256303526217E-03;

  q = vn / exp(-0.5 * dn * dn);

  kn[hook(0, 0)] = (unsigned int)((dn / q) * m1);
  kn[hook(0, 1)] = 0;

  wn[hook(2, 0)] = (float)(q / m1);
  wn[hook(2, 127)] = (float)(dn / m1);

  fn[hook(1, 0)] = 1.0;
  fn[hook(1, 127)] = (float)(exp(-0.5 * dn * dn));

  for (i = 126; 1 <= i; i--) {
    dn = sqrt(-2.0 * log(vn / dn + exp(-0.5 * dn * dn)));
    kn[hook(0, i + 1)] = (unsigned int)((dn / tn) * m1);
    tn = dn;
    fn[hook(1, i)] = (float)(exp(-0.5 * dn * dn));
    wn[hook(2, i)] = (float)(dn / m1);
  }

  return;
}