//{"EG":3,"RB":2,"RF":1,"T":0,"TCONV":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt4_kernel(global const float* T, global const float* RF, global float* RB, global const float* EG, const float TCONV) {
  float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  float ALOGT = log(TEMP);

  const float SMALL_INV = 1e+20f;

  const float RU = 8.31451e7f;
  const float PATM = 1.01325e6f;
  const float PFAC = ((PATM) * (1.0f / ((RU * (TEMP)))));

  float rtemp_inv;

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((51) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((51) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((52) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((52) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((53) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((53) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((54) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((54) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((55) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((55) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((56) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((56) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((57) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((57) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((58) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((58) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / ((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((59) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((59) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((60) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((60) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((61) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((61) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((62) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((62) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((63) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((63) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((64) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((64) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((65) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((65) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((66) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((66) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / ((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((67) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((67) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / ((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((68) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((68) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / ((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((69) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((69) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((70) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((70) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((71) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((71) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((72) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((72) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((73) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((73) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((74) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((74) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((75) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((75) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);
}