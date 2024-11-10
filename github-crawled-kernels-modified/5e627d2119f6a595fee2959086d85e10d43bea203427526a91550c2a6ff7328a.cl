//{"A":2,"RB":1,"RF":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void qssa_kernel(global float* RF, global float* RB, global float* A) {
  float DEN;

  (RF[hook(0, (((57) - 1) * (4)) + (get_global_id(0)))]) = 0.e0;
  (RF[hook(0, (((58) - 1) * (4)) + (get_global_id(0)))]) = 0.e0;
  (RF[hook(0, (((143) - 1) * (4)) + (get_global_id(0)))]) = 0.e0;
  (RF[hook(0, (((179) - 1) * (4)) + (get_global_id(0)))]) = 0.e0;
  (RB[hook(1, (((194) - 1) * (4)) + (get_global_id(0)))]) = 0.e0;
  (RF[hook(0, (((206) - 1) * (4)) + (get_global_id(0)))]) = 0.e0;

  DEN = +(RF[hook(0, (((34) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((35) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((36) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((37) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((38) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((39) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((40) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((77) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((87) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((105) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((111) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((54) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((60) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((1) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((34) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((37) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((39) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((57) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((77) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((105) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((111) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((1) * (11)) + 2)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((36) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((54) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((1) * (11)) + 3)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((60) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((1) * (11)) + 4)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((35) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((38) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((40) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((1) * (11)) + 7)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((87) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((48) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((49) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((50) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((51) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((52) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((53) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((54) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((55) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((56) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((91) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((106) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((112) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((165) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((36) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((59) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((67) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((68) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((69) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((80) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((117) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((123) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((125) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((130) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((160) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((2) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((48) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((49) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((52) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((53) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((55) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((56) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((57) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((58) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((58) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((80) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((91) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((106) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((117) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((130) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((160) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((165) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((2) * (11)) + 1)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((36) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((54) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((2) * (11)) + 3)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((59) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((67) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((68) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((69) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((2) * (11)) + 4)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((50) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((51) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((2) * (11)) + 6)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((123) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((125) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((2) * (11)) + 7)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((112) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((59) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((60) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((61) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((62) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((63) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((64) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((65) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((66) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((67) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((68) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((69) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((70) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((92) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((107) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((166) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((167) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((183) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((81) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((98) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((108) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((3) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((61) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((63) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((64) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((65) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((66) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((70) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((81) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((92) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((107) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((108) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((167) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((3) * (11)) + 1)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((60) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((3) * (11)) + 2)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((59) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((67) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((68) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((69) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((3) * (11)) + 4)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((62) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((3) * (11)) + 5)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((98) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((3) * (11)) + 6)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((166) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((3) * (11)) + 8)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((183) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((41) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((42) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((43) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((44) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((45) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((46) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((47) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((88) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((89) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((120) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((164) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((189) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((35) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((38) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((40) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((50) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((51) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((62) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((72) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((73) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((74) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((75) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((76) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((90) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((140) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((149) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((159) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((4) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((41) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((42) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((43) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((44) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((45) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((46) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((47) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((72) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((73) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((74) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((75) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((76) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((88) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((89) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((90) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((143) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((159) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((179) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((189) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((194) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((4) * (11)) + 1)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((35) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((38) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((40) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((4) * (11)) + 2)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((50) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((51) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((4) * (11)) + 3)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((62) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((4) * (11)) + 7)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((120) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((140) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((4) * (11)) + 8)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((164) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((4) * (11)) + 9)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((149) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((96) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((97) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((98) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((99) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((100) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((101) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((71) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((82) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((85) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((5) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((71) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((82) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((85) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((96) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((97) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((99) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((100) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((101) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((5) * (11)) + 3)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((98) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((122) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((123) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((124) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((125) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((114) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((134) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((155) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((166) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((186) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((6) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((114) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((122) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((124) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((155) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((186) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((6) * (11)) + 2)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((123) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((125) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((6) * (11)) + 3)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((166) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((6) * (11)) + 7)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((134) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((115) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((132) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((133) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((134) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((135) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((136) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((137) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((138) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((139) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((140) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((141) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((142) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((144) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((145) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((146) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((87) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((112) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((120) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((157) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((158) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((161) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((162) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((168) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((188) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((7) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((115) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((132) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((133) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((135) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((136) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((137) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((138) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((142) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((143) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((144) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((145) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((146) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((157) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((158) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((161) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((162) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((168) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((188) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((206) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((7) * (11)) + 1)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((87) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((7) * (11)) + 2)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((112) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((7) * (11)) + 4)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((120) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((140) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((7) * (11)) + 6)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((134) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((7) * (11)) + 9)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((139) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((141) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((170) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((171) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((172) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((173) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((174) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((175) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((176) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((177) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((178) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((94) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((156) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((164) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((180) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((181) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((182) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((183) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((184) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((199) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((201) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((204) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((8) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((94) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((156) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((170) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((171) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((172) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((173) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((174) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((175) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((176) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((177) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((178) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((179) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((180) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((181) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((182) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((184) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((194) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((206) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((8) * (11)) + 3)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((183) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((8) * (11)) + 4)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((164) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((8) * (11)) + 10)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((199) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((201) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((204) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((147) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((148) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((149) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((150) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((151) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((152) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((153) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((154) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((126) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((139) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((141) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((9) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((126) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((147) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((148) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((150) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((151) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((152) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((153) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((154) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((9) * (11)) + 4)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((149) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
  (A[hook(2, ((((((9) * (11)) + 7)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((139) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((141) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  DEN = +(RF[hook(0, (((199) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((200) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((201) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((202) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((203) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((204) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((205) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((169) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((190) - 1) * (4)) + (get_global_id(0)))]);
  (A[hook(2, ((((((10) * (11)) + 0)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RF[hook(0, (((169) - 1) * (4)) + (get_global_id(0)))]) + (RF[hook(0, (((190) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((200) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((202) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((203) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((205) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));

  (A[hook(2, ((((((10) * (11)) + 8)) - 1) * (4)) + (get_global_id(0)))]) = (((+(RB[hook(1, (((199) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((201) - 1) * (4)) + (get_global_id(0)))]) + (RB[hook(1, (((204) - 1) * (4)) + (get_global_id(0)))]))) * (1.0f / (DEN)));
}