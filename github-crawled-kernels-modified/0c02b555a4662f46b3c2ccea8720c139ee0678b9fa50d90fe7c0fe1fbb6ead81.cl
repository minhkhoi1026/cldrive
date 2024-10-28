//{"C":1,"RB":3,"RF":2,"RKLOW":4,"T":0,"TCONV":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratxb_kernel(global const float* T, global const float* C, global float* RF, global float* RB, global const float* RKLOW, const float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log((TEMP));
  float CTOT = 0.0f;
  float PR, PCOR, PRLOG, FCENT, FCLOG, XN;
  float CPRLOG, FLOG, FC, SQR;

  const float SMALL = 0x1.0p-126f;

  for (unsigned int k = 1; k <= 22; k++) {
    CTOT += (C[hook(1, (((k) - 1) * (4)) + (get_global_id(0)))]);
  }

  float CTB_5 = CTOT - (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) - (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) - (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);
  float CTB_9 = CTOT - 2.7e-1f * (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) + 2.65e0f * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);
  float CTB_10 = CTOT + (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) + 5.e0 * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) + 5.e-1 * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);
  float CTB_11 = CTOT + 1.4e0f * (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) + 1.44e1f * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) + 7.5e-1f * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) + 2.6e0f * (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);
  float CTB_12 = CTOT - (C[hook(1, (((4) - 1) * (4)) + (get_global_id(0)))]) - (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) - 2.5e-1f * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) + 5.e-1 * (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 5.e-1 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) - (C[hook(1, (((22) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);
  float CTB_29 = CTOT + (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) + 5.e0 * (C[hook(1, (((4) - 1) * (4)) + (get_global_id(0)))]) + 5.e0 * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) + 5.e-1 * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) + 2.5e0f * (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]);
  float CTB_190 = CTOT + (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) + 5.e0 * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) + 5.e-1 * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) + (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) + 2.e0 * (C[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]);

  (RF[hook(2, (((5) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((5) - 1) * (4)) + (get_global_id(0)))]) * CTB_5 * (C[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))]) * (C[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))]);
  (RB[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * CTB_5 * (C[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]);
  (RF[hook(2, (((9) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((9) - 1) * (4)) + (get_global_id(0)))]) * CTB_9 * (C[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))]) * (C[hook(1, (((5) - 1) * (4)) + (get_global_id(0)))]);
  (RB[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) * CTB_9 * (C[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]);
  (RF[hook(2, (((10) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((10) - 1) * (4)) + (get_global_id(0)))]) * CTB_10 * (C[hook(1, (((3) - 1) * (4)) + (get_global_id(0)))]) * (C[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))]);
  (RB[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * CTB_10 * (C[hook(1, (((5) - 1) * (4)) + (get_global_id(0)))]);
  (RF[hook(2, (((11) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((11) - 1) * (4)) + (get_global_id(0)))]) * CTB_11 * (C[hook(1, (((3) - 1) * (4)) + (get_global_id(0)))]) * (C[hook(1, (((3) - 1) * (4)) + (get_global_id(0)))]);
  (RB[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) * CTB_11 * (C[hook(1, (((4) - 1) * (4)) + (get_global_id(0)))]);
  (RF[hook(2, (((12) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((12) - 1) * (4)) + (get_global_id(0)))]) * CTB_12 * (C[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))]) * (C[hook(1, (((4) - 1) * (4)) + (get_global_id(0)))]);
  (RB[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * CTB_12 * (C[hook(1, (((7) - 1) * (4)) + (get_global_id(0)))]);
  (RF[hook(2, (((29) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((29) - 1) * (4)) + (get_global_id(0)))]) * CTB_29 * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) * (C[hook(1, (((3) - 1) * (4)) + (get_global_id(0)))]);
  (RB[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))]) * CTB_29 * (C[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]);
  (RF[hook(2, (((46) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((46) - 1) * (4)) + (get_global_id(0)))]) * CTB_10;
  (RB[hook(3, (((46) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((46) - 1) * (4)) + (get_global_id(0)))]) * CTB_10 * (C[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) * (C[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))]);
  (RF[hook(2, (((121) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((121) - 1) * (4)) + (get_global_id(0)))]) * CTOT * (C[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) * (C[hook(1, (((9) - 1) * (4)) + (get_global_id(0)))]);
  (RB[hook(3, (((121) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((121) - 1) * (4)) + (get_global_id(0)))]) * CTOT * (C[hook(1, (((20) - 1) * (4)) + (get_global_id(0)))]);

  PR = (RKLOW[hook(4, (((13) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((126) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 6.63e-1f * exp(((-TEMP) * (1.0f / (1.707e3f)))) + 3.37e-1f * exp(((-TEMP) * (1.0f / (3.2e3f)))) + exp(((-4.131e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((126) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((126) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((126) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((126) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((14) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((132) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 2.18e-1f * exp(((-TEMP) * (1.0f / (2.075e2f)))) + 7.82e-1f * exp(((-TEMP) * (1.0f / (2.663e3f)))) + exp(((-6.095e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((132) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((132) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((132) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((132) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((15) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((145) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 8.25e-1f * exp(((-TEMP) * (1.0f / (1.3406e3f)))) + 1.75e-1f * exp(((-TEMP) * (1.0f / (6.e4f)))) + exp(((-1.01398e4f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((145) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((145) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((145) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((145) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((16) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((148) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 4.5e-1f * exp(((-TEMP) * (1.0f / (8.9e3f)))) + 5.5e-1f * exp(((-TEMP) * (1.0f / (4.35e3f)))) + exp(((-7.244e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((148) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((148) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((148) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((148) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((17) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((155) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 2.655e-1f * exp(((-TEMP) * (1.0f / (1.8e2f)))) + 7.345e-1f * exp(((-TEMP) * (1.0f / (1.035e3f)))) + exp(((-5.417e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((155) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((155) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((155) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((155) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((18) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((156) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 2.47e-2f * exp(((-TEMP) * (1.0f / (2.1e2f)))) + 9.753e-1f * exp(((-TEMP) * (1.0f / (9.84e2f)))) + exp(((-4.374e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((156) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((156) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((156) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((156) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((19) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((170) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 1.578e-1f * exp(((-TEMP) * (1.0f / (1.25e2f)))) + 8.422e-1f * exp(((-TEMP) * (1.0f / (2.219e3f)))) + exp(((-6.882e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((170) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((170) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((170) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((170) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((20) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_10) * (1.0f / ((RF[hook(2, (((185) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 9.8e-1f * exp(((-TEMP) * (1.0f / (1.0966e3f)))) + 2.e-2 * exp(((-TEMP) * (1.0f / (1.0966e3f)))) + exp(((-6.8595e3f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((185) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((185) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((185) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((185) - 1) * (4)) + (get_global_id(0)))]) * PCOR;

  PR = (RKLOW[hook(4, (((21) - 1) * (4)) + (get_global_id(0)))]) * ((CTB_190) * (1.0f / ((RF[hook(2, (((190) - 1) * (4)) + (get_global_id(0)))]))));
  PCOR = ((PR) * (1.0f / ((1.0 + PR))));
  PRLOG = log10(fmax(PR, SMALL));
  FCENT = 0.e0 * exp(((-TEMP) * (1.0f / (1.e3f)))) + 1.e0 * exp(((-TEMP) * (1.0f / (1.31e3f)))) + exp(((-4.8097e4f) * (1.0f / (TEMP))));
  FCLOG = log10(fmax(FCENT, SMALL));
  XN = 0.75 - 1.27 * FCLOG;
  CPRLOG = PRLOG - (0.4 + 0.67 * FCLOG);
  SQR = ((CPRLOG) * (1.0f / ((XN - 0.14 * CPRLOG))));
  FLOG = ((FCLOG) * (1.0f / ((1.0 + SQR * SQR))));
  FC = exp10(FLOG);
  PCOR = FC * PCOR;
  (RF[hook(2, (((190) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(2, (((190) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
  (RB[hook(3, (((190) - 1) * (4)) + (get_global_id(0)))]) = (RB[hook(3, (((190) - 1) * (4)) + (get_global_id(0)))]) * PCOR;
}