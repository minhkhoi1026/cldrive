//{"EG":3,"RB":2,"RF":1,"T":0,"TCONV":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt8_kernel(global const float* T, global const float* RF, global float* RB, global const float* EG, const float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log(TEMP);

  const float SMALL_INV = 1e+20f;

  const float RU = 8.31451e7f;
  const float PATM = 1.01325e6f;
  const float PFAC = ((PATM) * (1.0f / ((RU * (TEMP)))));

  float rtemp_inv;

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((151) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((151) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((152) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((152) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((153) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((153) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((27) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((154) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((154) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = (((EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((155) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((155) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((156) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((156) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((157) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((157) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((158) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((158) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((159) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((159) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((160) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((160) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((161) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((161) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((162) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((162) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((28) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((163) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((163) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((164) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((164) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((165) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((165) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((166) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((166) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((167) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((167) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((168) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((168) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((169) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((169) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((170) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((170) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((171) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((171) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((172) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((172) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((28) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((173) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((173) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((174) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((174) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((175) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((175) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);
}