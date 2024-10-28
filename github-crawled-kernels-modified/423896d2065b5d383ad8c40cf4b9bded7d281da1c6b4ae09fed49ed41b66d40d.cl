//{"EG":3,"RB":2,"RF":1,"T":0,"TCONV":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt3_kernel(global const float* T, global const float* RF, global float* RB, global const float* EG, const float TCONV) {
  float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  float ALOGT = log(TEMP);

  const float SMALL_INV = 1e+20f;

  const float RU = 8.31451e7f;
  const float PATM = 1.01325e6f;
  const float PFAC = ((PATM) * (1.0f / ((RU * (TEMP)))));

  float rtemp_inv;

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((26) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((26) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((27) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((27) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((28) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((28) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((29) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((29) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((30) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((30) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((31) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((31) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((32) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((32) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((33) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((33) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((34) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((34) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((35) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((35) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((36) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((36) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((37) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((37) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((38) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((38) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((25) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((39) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((39) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((9) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((40) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((40) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((41) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((41) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((42) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((42) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((43) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((43) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((15) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((44) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((44) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((45) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((45) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((46) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((46) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((47) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((47) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((48) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((48) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((49) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((49) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((10) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((50) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((50) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);
}