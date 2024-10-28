//{"EG":3,"RB":2,"RF":1,"T":0,"TCONV":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt6_kernel(global const float* T, global const float* RF, global float* RB, global const float* EG, const float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log(TEMP);

  const float SMALL_INV = 1e+20f;

  const float RU = 8.31451e7f;
  const float PATM = 1.01325e6f;
  const float PFAC = ((PATM) * (1.0f / ((RU * (TEMP)))));

  float rtemp_inv;

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((18) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((101) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((101) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((102) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((102) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((103) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((103) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((104) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((104) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((105) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((105) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((106) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((106) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((107) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((107) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((108) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((108) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((109) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((109) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((110) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((110) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((111) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((111) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((112) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((112) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((113) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((113) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / ((EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((114) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((114) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((115) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((115) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((116) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((116) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((117) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((117) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((118) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((118) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((119) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((119) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((120) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((120) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((121) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((121) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / ((EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((122) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((122) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((123) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((123) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((124) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((124) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((125) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((125) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);
}