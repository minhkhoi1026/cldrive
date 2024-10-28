//{"EG":3,"RB":2,"RF":1,"T":0,"TCONV":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt2_kernel(global const float* T, global const float* RF, global float* RB, global const float* EG, const float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log(TEMP);

  const float SMALL_INV = 1e+20f;

  const float RU = 8.31451e7f;
  const float PATM = 1.01325e6f;
  const float PFAC = ((PATM) * (1.0f / ((RU * (TEMP)))));

  float rtemp_inv;

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((1) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((1) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((2) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((2) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((3) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((3) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((4) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((4) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((5) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((5) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((6) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((6) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((7) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((7) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((8) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((8) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((9) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((9) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((10) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((10) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((11) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((11) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((12) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((12) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((13) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((13) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((14) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((14) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((15) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((15) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((16) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((16) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((17) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((17) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((18) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((18) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((19) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((19) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((20) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((20) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((21) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((21) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((22) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((22) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((23) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((23) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((24) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((24) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((25) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((25) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);
}