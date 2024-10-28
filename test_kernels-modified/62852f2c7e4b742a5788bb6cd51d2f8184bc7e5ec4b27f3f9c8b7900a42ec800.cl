//{"EG":3,"RB":2,"RF":1,"T":0,"TCONV":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ratt9_kernel(global const float* T, global const float* RF, global float* RB, global const float* EG, const float TCONV) {
  const float TEMP = T[hook(0, get_global_id(0))] * TCONV;
  const float ALOGT = log(TEMP);

  const float SMALL_INV = 1e+20f;

  const float RU = 8.31451e7f;
  const float PATM = 1.01325e6f;
  const float PFAC = ((PATM) * (1.0f / ((RU * (TEMP)))));

  float rtemp_inv;

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((176) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((176) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((177) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((177) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((178) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((178) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((179) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((179) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((180) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((180) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((181) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((181) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((182) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((182) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((11) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((183) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((183) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((24) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((184) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((184) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((185) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((185) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((20) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((186) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((186) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((187) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((187) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((188) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((188) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((14) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((189) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((189) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]) * PFAC)) * (1.0f / ((EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))));
  (RB[hook(2, (((190) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((190) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((22) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((191) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((191) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((192) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((192) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((26) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((193) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((193) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((16) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((194) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((194) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((195) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((195) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((196) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((196) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((8) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((197) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((197) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((198) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((198) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((199) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((199) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((2) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((1) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((200) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((200) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((3) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((201) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((201) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((6) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((202) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((202) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((4) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((203) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((203) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((7) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((5) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((17) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]) * PFAC))));
  (RB[hook(2, (((204) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((204) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((31) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((13) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((30) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((205) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((205) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);

  rtemp_inv = ((((EG[hook(3, (((21) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((23) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (((EG[hook(3, (((12) - 1) * (4)) + (get_global_id(0)))]) * (EG[hook(3, (((29) - 1) * (4)) + (get_global_id(0)))])))));
  (RB[hook(2, (((206) - 1) * (4)) + (get_global_id(0)))]) = (RF[hook(1, (((206) - 1) * (4)) + (get_global_id(0)))]) * fmin(rtemp_inv, SMALL_INV);
}