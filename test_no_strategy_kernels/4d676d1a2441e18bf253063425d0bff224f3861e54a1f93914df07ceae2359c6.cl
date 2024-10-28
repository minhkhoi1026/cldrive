//{"C":1,"RB":3,"RF":2,"RKLOW":4,"T":0,"TCONV":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratx_kernel(global const float* T, global const float* C, global float* RF, global float* RB, global const float* RKLOW, const float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log((TEMP));
  float CTOT = 0.0;
  float PR, PCOR, PRLOG, FCENT, FCLOG, XN;
  float CPRLOG, FLOG, FC;
  float SQR;

  const float SMALL = 0x1.0p-126f;

  for (unsigned int k = 1; k <= 22; k++) {
    CTOT += (C[hook(1, (((k) - 1) * (4)) + (get_global_id(0)))]);
  }

  float CTB_10 = CTOT + (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) + 5.e0 * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) + 5.e-1 * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);
  float CTB_114 = CTOT + (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) + 5.e0 * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) + 5.e-1 * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) + 1.5e0f * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 1.5e0f * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);
  float CTB_16 = CTOT + (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) + 5.e0 * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) + 5.e-1 * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);

  PR = (RKLOW[hook(4, (((1) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_16) * (1.0f / ((RF[hook(2, (((16) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 2.654e-1f * exp(((-TEMP) * (1.0f / (9.4e1f)))) + 7.346e-1f * exp(((-TEMP) * (1.0f / (1.756e3f)))) + exp(((-5.182e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((16) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((16) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((2) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((31) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 6.8e-2f * exp(((-TEMP) * (1.0f / (1.97e2f)))) + 9.32e-1f * exp(((-TEMP) * (1.0f / (1.54e3f)))) + exp(((-1.03e4f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((31) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((31) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((3) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((39) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 4.243e-1f * exp(((-TEMP) * (1.0f / (2.37e2f)))) + 5.757e-1f * exp(((-TEMP) * (1.0f / (1.652e3f)))) + exp(((-5.069e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((39) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((39) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((39) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((39) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((4) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((41) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 2.176e-1f * exp(((-TEMP) * (1.0f / (2.71e2f)))) + 7.824e-1f * exp(((-TEMP) * (1.0f / (2.755e3f)))) + exp(((-6.57e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((41) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((41) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((41) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((41) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((5) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((48) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 3.2e-1f * exp(((-TEMP) * (1.0f / (7.8e1f)))) + 6.8e-1f * exp(((-TEMP) * (1.0f / (1.995e3f)))) + exp(((-5.59e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((48) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((48) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((48) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((48) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((6) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((56) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 4.093e-1f * exp(((-TEMP) * (1.0f / (2.75e2f)))) + 5.907e-1f * exp(((-TEMP) * (1.0f / (1.226e3f)))) + exp(((-5.185e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((56) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((56) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((56) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((56) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((7) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((71) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 2.42e-1f * exp(((-TEMP) * (1.0f / (9.4e1f)))) + 7.58e-1f * exp(((-TEMP) * (1.0f / (1.555e3f)))) + exp(((-4.2e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((71) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((71) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((71) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((71) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((8) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((78) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 2.17e-1f * exp(((-TEMP) * (1.0f / (7.4e1f)))) + 7.83e-1f * exp(((-TEMP) * (1.0f / (2.941e3f)))) + exp(((-6.964e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((78) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((78) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((78) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((78) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((9) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((89) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 3.827e-1f * exp(((-TEMP) * (1.0f / (1.3076e1f)))) + 6.173e-1f * exp(((-TEMP) * (1.0f / (2.078e3f)))) + exp(((-5.093e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((89) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((89) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((89) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((89) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((10) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((93) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 4.675e-1f * exp(((-TEMP) * (1.0f / (1.51e2f)))) + 5.325e-1f * exp(((-TEMP) * (1.0f / (1.038e3f)))) + exp(((-4.97e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((93) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((93) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((93) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((93) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((11) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_114) * (1.0f / ((RF[hook(2, (((114) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  (RF[hook(2, (((114) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((114) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((114) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((114) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((12) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((115) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = -9.816e-1f * exp(((-TEMP) * (1.0f / (5.3837e3f)))) + 1.9816e0f * exp(((-TEMP) * (1.0f / (4.2932e0f)))) + exp(((7.95e-2f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((115) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((115) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((115) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((115) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
}