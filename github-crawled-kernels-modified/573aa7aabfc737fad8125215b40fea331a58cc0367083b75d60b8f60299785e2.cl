//{"EG":3,"RB":2,"RF":1,"T":0,"TCONV":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt7_kernel(global const float* T, global const float* RF, global float* RB, global const float* EG, const float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log(TEMP);

  const float SMALL_INV = 1e+20f;

  const float RU = 8.31451e7f;
  const float PATM = 1.01325e6f;
  const float PFAC = ((PATM) * (1.0f / ((RU * (TEMP)))));

  float rtemp_inv;

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((126) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((126) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((127) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((127) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((128) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((128) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((129) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((129) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((130) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((130) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((131) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((131) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((132) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((132) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((133) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((133) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((134) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((134) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((135) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((135) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((136) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((136) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((137) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((137) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((138) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((138) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((139) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((139) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((140) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((140) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((141) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((141) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((142) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((142) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((143) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((143) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((19) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((144) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((144) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((145) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((145) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((146) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((146) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((147) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((147) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((28) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((148) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((148) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((149) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((149) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((150) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((150) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);
}