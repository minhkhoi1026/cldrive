//{"C":3,"P":0,"PCONV":5,"T":1,"TCONV":4,"Y":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void gr_base(global const float* P, global const float* T, global const float* Y, global float* C, const float TCONV, const float PCONV) {
  const float TEMP = T[hook(1, get_global_id(0))] * TCONV;
  const float PRES = P[hook(0, get_global_id(0))] * PCONV;

  const float SMALL = 0x1.0p-126f;

  float SUM, ctmp;

  SUM = 0.0;

  (C[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((1) - 1) * (4)) + (get_global_id(0)))]) * 4.96046521e-1f;
  SUM += ctmp;
  (C[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((2) - 1) * (4)) + (get_global_id(0)))]) * 9.92093043e-1f;
  SUM += ctmp;
  (C[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((3) - 1) * (4)) + (get_global_id(0)))]) * 6.25023433e-2f;
  SUM += ctmp;
  (C[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((4) - 1) * (4)) + (get_global_id(0)))]) * 3.12511716e-2f;
  SUM += ctmp;
  (C[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((5) - 1) * (4)) + (get_global_id(0)))]) * 5.87980383e-2f;
  SUM += ctmp;
  (C[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((6) - 1) * (4)) + (get_global_id(0)))]) * 5.55082499e-2f;
  SUM += ctmp;
  (C[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((7) - 1) * (4)) + (get_global_id(0)))]) * 3.02968146e-2f;
  SUM += ctmp;
  (C[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((8) - 1) * (4)) + (get_global_id(0)))]) * 2.93990192e-2f;
  SUM += ctmp;
  (C[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((9) - 1) * (4)) + (get_global_id(0)))]) * 6.65112065e-2f;
  SUM += ctmp;
  (C[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((10) - 1) * (4)) + (get_global_id(0)))]) * 6.23323639e-2f;
  SUM += ctmp;
  (C[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((11) - 1) * (4)) + (get_global_id(0)))]) * 3.57008335e-2f;
  SUM += ctmp;
  (C[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((12) - 1) * (4)) + (get_global_id(0)))]) * 2.27221341e-2f;
  SUM += ctmp;
  (C[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((13) - 1) * (4)) + (get_global_id(0)))]) * 3.33039255e-2f;
  SUM += ctmp;
  (C[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((14) - 1) * (4)) + (get_global_id(0)))]) * 3.84050525e-2f;
  SUM += ctmp;
  (C[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((15) - 1) * (4)) + (get_global_id(0)))]) * 3.56453112e-2f;
  SUM += ctmp;
  (C[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((16) - 1) * (4)) + (get_global_id(0)))]) * 3.32556033e-2f;
  SUM += ctmp;
  (C[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((17) - 1) * (4)) + (get_global_id(0)))]) * 2.4372606e-2f;
  SUM += ctmp;
  (C[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((18) - 1) * (4)) + (get_global_id(0)))]) * 2.37882046e-2f;
  SUM += ctmp;
  (C[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((19) - 1) * (4)) + (get_global_id(0)))]) * 2.26996304e-2f;
  SUM += ctmp;
  (C[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((20) - 1) * (4)) + (get_global_id(0)))]) * 2.43467162e-2f;
  SUM += ctmp;
  (C[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((21) - 1) * (4)) + (get_global_id(0)))]) * 2.37635408e-2f;
  SUM += ctmp;
  (C[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]) = ctmp = (Y[hook(2, (((22) - 1) * (4)) + (get_global_id(0)))]) * 3.56972032e-2f;
  SUM += ctmp;

  SUM = ((PRES) * (1.0f / ((SUM * (TEMP)*8.314510e7f))));

  for (unsigned k = 1; k <= 22; k++) {
    (C[hook(3, (((k) - 1) * (4)) + (get_global_id(0)))]) = fmax((C[hook(3, (((k) - 1) * (4)) + (get_global_id(0)))]), SMALL) * SUM;
  }
}