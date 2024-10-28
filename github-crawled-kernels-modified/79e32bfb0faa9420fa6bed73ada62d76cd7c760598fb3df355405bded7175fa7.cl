//{"EG":3,"RB":2,"RF":1,"T":0,"TCONV":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt5_kernel(global const float* T, global const float* RF, global float* RB, global const float* EG, const float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log(TEMP);

  const float SMALL_INV = 1e+20f;

  const float RU = 8.31451e7f;
  const float PATM = 1.01325e6f;
  const float PFAC = ((PATM) * (1.0f / ((RU * (TEMP)))));

  float rtemp_inv;

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((76) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((76) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((77) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((77) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((78) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((78) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((79) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((79) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((80) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((80) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((81) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((81) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((82) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((82) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((83) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((83) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((84) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((84) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((85) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((85) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((86) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((86) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((87) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((87) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((88) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((88) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((28) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((89) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((89) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((90) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((90) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((91) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((91) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((92) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((92) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((93) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((93) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((94) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((94) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((95) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((95) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((96) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((96) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((97) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((97) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((98) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((98) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((99) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((99) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((100) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((100) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);
}